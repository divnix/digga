{ lib }:
let
  inherit (builtins) mapAttrs attrNames attrValues head isFunction;
in

_: { self, inputs, ... } @ args:
let

  config = lib.mkFlake.evalArgs {
    inherit args;
  };

  cfg = config.config;

  otherArguments = removeAttrs args (attrNames config.options);

  defaultModules = with lib.modules; [
    (hmDefaults {
      inherit (cfg.home) suites;
      modules = cfg.home.modules ++ cfg.home.externalModules;
    })
    (globalDefaults {
      inherit self inputs;
    })
  ];

  stripChannel = channel: removeAttrs channel [
    # arguments in our channels api that shouldn't be passed to fup
    "overlays"
  ];
  getDefaultChannel = channels: channels.${cfg.nixos.hostDefaults.channelName};

  # evalArgs sets channelName and system to null by default
  # but for proper default handling in fup, null args have to be removed
  stripHost = args: removeAttrs (lib.filterAttrs (_: arg: arg != null) args) [
    # arguments in our hosts/hostDefaults api that shouldn't be passed to fup
    "externalModules"
  ];
  hosts = lib.mapAttrs (_: stripHost) cfg.nixos.hosts;
  hostDefaults = stripHost cfg.nixos.hostDefaults;
in
lib.systemFlake (lib.mergeAny
  {
    inherit self inputs hosts;
    inherit (cfg) channelsConfig supportedSystems;

    channels = mapAttrs
      (name: channel:
        stripChannel (channel // {
          # pass channels if "overlay" has three arguments
          overlaysBuilder = channels: lib.unifyOverlays channels channel.overlays;
        })
      )
      cfg.channels;

    sharedOverlays = [
      (final: prev: {
        __dontExport = true;
        lib = prev.lib.extend (lfinal: lprev: {
          # digga lib can be accessed in packages as lib.digga
          digga = lib;
        });
      })
    ];
    hostDefaults = lib.mergeAny hostDefaults {
      specialArgs.suites = cfg.nixos.suites;
      modules = cfg.nixos.hostDefaults.externalModules ++ defaultModules;
      builder = args: args.specialArgs.channel.input.lib.nixosSystem (lib.mergeAny args {
        # So modules and functions can create their own version of the build
        modules = [{ lib.builderArgs = args; }];
      });
    };

    nixosModules = lib.exporter.modulesFromList cfg.nixos.hostDefaults.modules;

    homeModules = lib.exporter.modulesFromList cfg.home.modules;

    overlays = lib.exporter.overlaysFromChannelsExporter {
      # since we can't detect overlays owned by self
      # we have to filter out ones exported by the inputs
      # optimally we would want a solution for NixOS/nix#4740
      inherit inputs;
      inherit (self) pkgs;
    };

    packagesBuilder = lib.builder.packagesFromOverlaysBuilderConstructor self.overlays;

    checksBuilder = channels:
      lib.pkgs-lib.tests.mkChecks {
        pkgs = getDefaultChannel channels;
        inherit (self.deploy) nodes;
        hosts = self.nixosConfigurations;
        homes = self.homeConfigurations or { };
      };

    devShellBuilder = channels:
      lib.pkgs-lib.shell {
        pkgs = getDefaultChannel channels;
        extraModules = cfg.devshellModules;
      };
  }
  otherArguments # for overlays list order
)

{ lib }:
let
  inherit (builtins) mapAttrs attrNames attrValues head isFunction;
in

_: { self, ... } @ args:
let

  config = lib.mkFlake.evalArgs {
    inherit args;
  };

  cfg = config.config;

  otherArguments = removeAttrs args (attrNames config.options);

  defaultModules = with lib.modules; [
    (hmDefaults {
      specialArgs = cfg.home.importables;
      modules = cfg.home.modules ++ cfg.home.externalModules;
    })
    (globalDefaults {
      inherit self;
    })
    ({ ... }@args: {
      lib.specialArgs = args.specialArgs or (builtins.trace ''
        WARNING: specialArgs is not accessibly by the module system which means you
        are likely using NixOS 20.09. Profiles testing and custom builds (ex: iso)
        are not supported in 20.09 and using them could result in infinite
        recursion errors. It is recommended to update to 21.05 to use either feature.
      '' { });
    })
    customBuilds
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
    inherit self hosts;
    inherit (self) inputs;
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
      specialArgs = cfg.nixos.importables;
      modules = cfg.nixos.hostDefaults.externalModules ++ defaultModules;
    };

    nixosModules = lib.exporters.modulesFromList cfg.nixos.hostDefaults.modules;

    homeModules = lib.exporters.modulesFromList cfg.home.modules;

    devshellModules = lib.exporters.modulesFromList {
      paths = cfg.devshell.modules;
      _import = lib.maybeImportDevshellModule;
    };

    overlays = lib.exporters.internalOverlays {
      # since we can't detect overlays owned by self
      # we have to filter out ones exported by the inputs
      # optimally we would want a solution for NixOS/nix#4740
      inherit (self) pkgs inputs;
    };

    outputsBuilder = channels:
      let
        defaultChannel = channels.${cfg.nixos.hostDefaults.channelName};
      in
      lib.mergeAny
        {
          packages = lib.exporters.fromOverlays self.overlays channels;

          checks = lib.pkgs-lib.tests.mkChecks {
            pkgs = defaultChannel;
            inherit (self.deploy) nodes;
            hosts = self.nixosConfigurations;
            homes = self.homeConfigurations or { };
          };

          devShell = lib.pkgs-lib.shell {
            pkgs = defaultChannel;
            extraModules = cfg.devshell.modules ++ cfg.devshell.externalModules;
          };
        }
        (cfg.outputsBuilder channels);

  }

  otherArguments # for overlays list order
)

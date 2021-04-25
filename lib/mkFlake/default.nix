{ lib, deploy }:
let
  inherit (lib) os;
  inherit (builtins) mapAttrs attrNames attrValues head isFunction;
in

_: { self, inputs, ... } @ args:
let

  config = lib.mkFlake.evalArgs {
    args = lib.mkMerge [ args { _module.check = false; } ];
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

  getDefaultChannel = channels: channels.${cfg.nixos.hostDefaults.channelName};
in
lib.systemFlake (lib.recursiveUpdate
  otherArguments
  {
    inherit self inputs;
    inherit (cfg) channelsConfig supportedSystems;

    mkFlakeConfig = config;

    channels = mapAttrs
      (name: channel:
        channel // {
          # pass channels if "overlay" has three arguments
          overlaysBuilder = channels: lib.unifyOverlays channels channel.overlays;
        }
      ) cfg.channels;

    # the host arguments cannot exist for fup hostDefaults to work
    # so evalArgs sets them to null by default and the null args are filtered out here
    hosts = mapAttrs (_: host: lib.filterAttrs (_: arg: arg != null) host) cfg.nixos.hosts;

    hostDefaults = {
      specialArgs.suites = cfg.nixos.suites;
      modules = cfg.nixos.hostDefaults.modules
        ++ cfg.nixos.hostDefaults.externalModules
        ++ defaultModules;
      builder = os.devosSystem { inherit self inputs; };
      inherit (cfg.nixos.hostDefaults)
        channelName
        system;
    };

    nixosModules = lib.exporter.modulesFromList cfg.nixos.hostDefaults.modules;

    homeModules = lib.exporter.modulesFromList cfg.home.modules;
    homeConfigurations = os.mkHomeConfigurations self.nixosConfigurations;

    deploy.nodes = os.mkNodes deploy self.nixosConfigurations;

    overlays = lib.exporter.overlaysFromChannelsExporter { inherit (self) pkgs inputs; };

    packagesBuilder = lib.builder.packagesFromOverlaysBuilderConstructor self.overlays;

    checksBuilder = channels:
      lib.pkgs-lib.tests.mkChecks {
        pkgs = getDefaultChannel channels;
        inherit (self.deploy) nodes;
        hosts = self.nixosConfigurations;
        homes = self.homeConfigurations;
      };

    devShellBuilder = channels:
      lib.pkgs-lib.shell {
        pkgs = getDefaultChannel channels;
      };
  }
)

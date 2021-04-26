{ lib, deploy }:
let
  inherit (lib) os;
  inherit (builtins) mapAttrs attrNames attrValues head isFunction;
in

_: { self, inputs, ... } @ args:
let

  config = lib.mkFlake.evalArgs {
    args = args // { _module.check = false; };
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

  defaultChannelName = cfg.os.hostDefaults.channelName;
  getDefaultChannel = channels: channels.${cfg.os.hostDefaults.channelName};
in
lib.systemFlake (lib.recursiveUpdate
  otherArguments
  {
    inherit self inputs;

    channels = mapAttrs
      (name: channel:
        channel // {
          # pass channels if "overlay" has three arguments
          overlaysBuilder = channels: lib.unifyOverlays channels channel.overlays;
        }
      ) cfg.channels;

    inherit (cfg.nixos) hosts;

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

    nixosModules = lib.exporters.moduleFromListExporter cfg.os.hostDefaults.modules;

    homeModules = lib.exporters.moduleFromListExporter cfg.home.modules;
    homeConfigurations = os.mkHomeConfigurations self.nixosConfigurations;

    deploy.nodes = os.mkNodes deploy self.nixosConfigurations;

    overlays = lib.exporters.overlaysFromChannelsExporter { inherit (self) pkgs inputs; };

    packagesBuilder = lib.builders.packagesFromOverlaysBuilderConstructor self.overlays;

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

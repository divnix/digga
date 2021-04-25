{ lib, deploy }:
let
  inherit (lib) os;
  inherit (builtins) mapAttrs attrNames attrValues head isFunction;
in

_: { self, inputs, ... } @ args:
let

  config = lib.mkFlake.evalArgs { inherit args; };

  cfg = config.config;

  otherArguments = removeAttrs args (attrNames config.options);

  defaultChannelName = cfg.os.hostDefaults.channelName;
  getDefaultChannel = channels: channels.${cfg.os.hostDefaults.channelName};
in
lib.systemFlake
  lib.recursiveUpdate
  otherArguments
{
  inherit self inputs;

  channels = mapAttrs
    (name: channel:
      channel // {
        # pass channels if "overlay" has three arguments
        overlaysBuilder = channels: lib.unifyOverlays channels c.overlays;
      };
    ) cfg.channels;

  inherit (cfg.os) hosts;

  hostDefaults = {
    specialArgs.suites = cfg.os.suites;
    modules = cfg.os.hostDefaults.modules
      ++ cfg.os.hostDefaults.externalModules
      ++ with lib.modules; [
        (hmDefaults {
          inherit (cfg.home) suites;
          modules = cfg.home.modules ++ cfg.home.externalModules;
        })
        (globalDefaults {
          inherit self inputs;
        })
      ];
    builder = os.devosSystem { inherit self inputs; };
    inherit (cfg.os.hostDefaults)
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
    pkgs-lib.tests.mkChecks {
      pkgs = getDefaultChannel channels;
      inherit (self.deploy) nodes;
      hosts = self.nixosConfigurations;
      homes = self.homeConfigurations;
    };

  devShellBuilder = channels:
    pkgs-lib.shell {
      pkgs = getDefaultChannel channels;
    };
}

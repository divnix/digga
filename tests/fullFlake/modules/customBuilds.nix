{ lib, pkgs, self, config, modules, channel, ... }:
let
  mkBuild = buildModule:
    channel.input.lib.nixosSystem {
      inherit (pkgs) system;
      inherit (config.lib) specialArgs;
      modules = modules ++ [ buildModule ];
    };
in
{
  system.build = {
    iso = (mkBuild (config.lib.digga.modules.isoConfig {
      inherit self;
      fullHostConfig = config;
    })).config.system.build.isoImage;

    homes = (mkBuild ({ config, ... }: {
      home-manager.useUserPackages = lib.mkForce false;
      home-manager.sharedModules = [
        {
          home.sessionVariables = {
            inherit (config.environment.sessionVariables) NIX_PATH;
          };
          xdg.configFile."nix/registry.json".text =
            config.environment.etc."nix/registry.json".text;
        }
      ];
    })).config.home-manager.users;
  };
}

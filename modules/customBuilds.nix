{ lib, pkgs, self, config, modules, channel, ... }:
{
  system.build = {
    iso = (config.lib.digga.mkBuild
      (config.lib.digga.modules.isoConfig {
        inherit self;
        fullHostConfig = config;
      })
    ).config.system.build.isoImage;

    homes = (config.lib.digga.mkBuild
      ({ config, ... }: {
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
      })
    ).config.home-manager.users;
  };
}

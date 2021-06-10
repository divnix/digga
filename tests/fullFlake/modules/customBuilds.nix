{ lib, self, config, modules, channel, ... }:
let
  mkBuild = buildModule:
    # TODO: get specialArgs as a module argument and drop builderArgs usage
    channel.input.lib.nixosSystem (config.lib.digga.mergeAny config.lib.builderArgs {
      modules = [ buildModule ];
    });
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

    digitalOcean = (mkBuild ({ modulesPath, ... }: {
      imports = [ "${modulesPath}/virtualisation/digital-ocean-image.nix" ];
    })).config.system.build.digitalOceanImage;
  };
}

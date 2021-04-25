{ lib }:

# dependencies to return a builder
{ self, inputs }:

{ modules, specialArgs, ... } @ args:
specialArgs.channel.input.lib.nixosSystem
  (args // {
    modules =
      let
        fullHostConfig = (lib.nixosSystem (args // { inherit modules; })).config;

        isoConfig = (lib.nixosSystem
          (args // {
            modules = modules ++ [
              (lib.modules.iso { inherit self inputs fullHostConfig; })
            ];
          })).config;

        hmConfig = (lib.nixosSystem
          (args // {
            modules = modules ++ [
              (lib.modules.hmConfig)
            ];
          })).config;
      in
      modules ++ [{
        system.build = {
          iso = isoConfig.system.build.isoImage;
          homes = hmConfig.home-manager.users;
        };
      }];
  })

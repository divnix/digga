{ lib }:

# dependencies to return a builder
{ self, inputs }:

{ modules, specialArgs, ... } @ args:
let inherit (specialArgs.channel.input.lib) nixosSystem; in
nixosSystem
  (args // {
    modules =
      let
        fullHostConfig = (nixosSystem (args // { inherit modules; })).config;

        isoConfig = (nixosSystem
          (args // {
            modules = modules ++ [
              (lib.modules.iso { inherit self inputs fullHostConfig; })
            ];
          })).config;

        hmConfig = (nixosSystem
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
        lib = {
          inherit specialArgs;
          testModule = {
            imports = modules;
          };
        };
      }];
  })

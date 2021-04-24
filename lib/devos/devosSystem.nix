{ lib }:

{ self, nixos, inputs, modules, ... } @ allArgs:
let args = builtins.removeAttrs allArgs [ "self" "nixos" "inputs" ]; in
lib.nixosSystem (args // {
  modules =
    let
      moduleList = builtins.attrValues modules;

      fullHostConfig = (lib.nixosSystem (args // { modules = moduleList; })).config;

      isoConfig = (lib.nixosSystem
        (args // {
          modules = moduleList ++ [
            (lib.modules.iso { inherit self nixos inputs fullHostConfig; })
          ];
        })).config;
      hmConfig = (lib.nixosSystem
        (args // {
          modules = moduleList ++ [
            (lib.modules.hmConfig)
          ];
        })).config;
    in
    moduleList ++ [{
      system.build = {
        iso = isoConfig.system.build.isoImage;
        homes = hmConfig.home-manager.users;
      };
    }];
})

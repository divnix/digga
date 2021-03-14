{ lib, nixos, ... }:

{ modules, ... } @ args:
lib.nixosSystem (args // {
  modules =
    let
      modpath = "nixos/modules";
      cd = "installer/cd-dvd/installation-cd-minimal-new-kernel.nix";

      isoConfig = (lib.nixosSystem
        (args // {
          modules = modules ++ [
            "${nixos}/${modpath}/${cd}"
            ({ config, ... }: {
              isoImage.isoBaseName = "nixos-" + config.networking.hostName;
              # confilcts with networking.wireless which might be slightly
              # more useful on a stick
              networking.networkmanager.enable = lib.mkForce false;
              # confilcts with networking.wireless
              networking.wireless.iwd.enable = lib.mkForce false;
            })
          ];
        })).config;
    in
    modules ++ [{
      system.build = {
        iso = isoConfig.system.build.isoImage;
      };
    }];
})

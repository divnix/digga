{ lib
, nixos
, master
, nixos-hardware
, pkgs
, self
, system
, externModules
, ...
}:
let
  inherit (lib.flk) recImport;
  inherit (builtins) attrValues removeAttrs;

  unstableModules = [ ];
  addToDisabledModules = [ ];

  libExt = lib.extend (
    final: prev: {
      nixosSystemExtended = { modules, ... } @ args:
        lib.nixosSystem (args // {
            modules =
              let
                isoConfig = (
                  import (nixos + "/nixos/lib/eval-config.nix")
                    (
                      args // {
                        modules = modules ++ [
                          (nixos + "/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix")
                          ({ config, ... }: {
                            isoImage.isoBaseName = "nixos-" + config.networking.hostName;
                          })
                        ];
                      }
                    )
                ).config;
              in
                modules ++ [
                  {
                    system.build = {
                      iso = isoConfig.system.build.isoImage;
                    };
                  }
                ];
          }
        );
    }
  );

  config = hostName:
    libExt.nixosSystemExtended {
      inherit system;

      specialArgs =
        {
          unstableModulesPath = "${master}/nixos/modules";
          hardware = nixos-hardware.nixosModules;
        };

      modules =
        let
          core = self.nixosModules.profiles.core;

          modOverrides = { config, unstableModulesPath, ... }: {
            disabledModules = unstableModules ++ addToDisabledModules;
            imports = map
              (path: "${unstableModulesPath}/${path}")
              unstableModules;
          };

          global = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            hardware.enableRedistributableFirmware = lib.mkDefault true;

            networking.hostName = hostName;
            nix.nixPath = let path = toString ../.; in
              [
                "nixos-unstable=${master}"
                "nixos=${nixos}"
              ];

            nixpkgs = { inherit pkgs; };

            nix.registry = {
              master.flake = master;
              nixflk.flake = self;
              nixpkgs.flake = nixos;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

          local = import "${toString ./.}/${hostName}.nix";

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues (removeAttrs self.nixosModules [ "profiles" ]);

        in
        flakeModules ++ [
          core
          global
          local
          modOverrides
        ] ++ externModules;

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts

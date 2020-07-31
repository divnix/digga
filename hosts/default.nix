{ home, nixpkgs, unstable, unstablePkgs, self, pkgs, system, utils, ... }:
let
  inherit (nixpkgs) lib;
  inherit (utils) recImport;
  inherit (builtins) attrValues removeAttrs;

  config = hostName:
    lib.nixosSystem {
      inherit system;

      modules =
        let
          inherit (home.nixosModules) home-manager;

          core = self.nixosModules.profiles.core;

          global = {
            networking.hostName = hostName;
            nix.nixPath = [
              "nixpkgs=${nixpkgs}"
              "nixos-config=/etc/nixos/configuration.nix"
              "nixpkgs-overlays=/etc/nixos/overlays"
            ];

            nixpkgs = { inherit pkgs; };

            nix.registry = {
              nixpkgs.flake = nixpkgs;
              nixflk.flake = self;
              master.flake = unstable;
            };
          };

          unstables = {
            systemd.package = unstablePkgs.systemd;
            nixpkgs.overlays = [
              (final: prev:
                with unstablePkgs; {
                  inherit starship element-desktop discord signal-desktop mpv
                    protonvpn-cli-ng dhall nixpkgs-fmt;
                }
              )
            ];
          };

          local = import "${toString ./.}/${hostName}.nix";

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues (removeAttrs self.nixosModules [ "profiles" ]);

        in
        flakeModules ++ [ core global local home-manager unstables ];

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts

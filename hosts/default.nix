inputs@{ home, nixpkgs, unstablePkgs, self, pkgs, system, ... }:
let
  inherit (nixpkgs) lib;

  utils = import ../lib/utils.nix { inherit lib; };

  inherit (utils) recImport;

  inherit (builtins) attrValues removeAttrs;

  config = hostName:
    lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit unstablePkgs;
        usr = { inherit utils; };
      };

      modules = let
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
        };

        local = import "${toString ./.}/${hostName}.nix";

        # Everything in `./modules/list.nix`.
        flakeModules =
          attrValues (removeAttrs self.nixosModules [ "profiles" ]);

      in flakeModules ++ [ core global local home-manager ];

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in hosts

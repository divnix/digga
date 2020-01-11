args@{ home, nixpkgs, self, ... }:
let
  inherit (nixpkgs) lib;

  utils = import ../lib/utils.nix { inherit lib; };

  inherit (utils) recImport;

  inherit (builtins) attrValues removeAttrs;

  config = hostName:
    lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs.usr = { inherit utils; };

      modules = let
        inherit (home.nixosModules) home-manager;

        core = ../profiles/core.nix;

        global = {
          networking.hostName = hostName;
          nix.nixPath = [
            "nixpkgs=${nixpkgs}"
            "nixos-config=/etc/nixos/configuration.nix"
            "nixpkgs-overlays=/etc/nixos/overlays"
          ];

          system.configurationRevision = self.rev;

          nixpkgs.overlays = self.overlays;
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

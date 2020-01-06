args@{ home, nixpkgs, self, ... }:
let
  utils = import ../lib/utils.nix { lib = nixpkgs.lib; };

  inherit (utils) recImport;

  inherit (builtins) attrValues removeAttrs;

  config = this:
    nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs.usr = utils;

      modules = let
        core = ../profiles/core.nix;

        global = {
          networking.hostName = this;
          nix.nixPath = [
            "nixpkgs=${nixpkgs}"
            "nixos-config=/etc/nixos/configuration.nix"
          ];
          system.configurationRevision = self.rev;

          nixpkgs.overlays = self.overlays;
        };

        local = import "${toString ./.}/${this}.nix";

        flakeModules = removeAttrs self.nixosModules [ "profiles" ];

      in attrValues flakeModules
      ++ [ core global local home.nixosModules.home-manager ];

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in hosts

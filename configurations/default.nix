{ home, nixpkgs, flake, ... }:
let
  utils = import ../lib/utils.nix { lib = nixpkgs.lib; };

  inherit (utils)
    reqImport
    vimport
    ;


  config = self:
    nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      modules = let
        core = ../profiles/core.nix;

        global = {
          networking.hostName = self;
          nix.nixPath = [
            "nixpkgs=${nixpkgs}"
            "nixos-config=/etc/nixos/configuration.nix"
          ];
          system.configurationRevision = flake.rev;
        };

        local = vimport ./. "${self}.nix";
      in
        [
          core
          global
          local
          home
        ];

    };

  configurations =
    reqImport { dir = ./.; _import = config; };
in
configurations

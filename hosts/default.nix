{ home, nixpkgs, flake, ... }:
let
  utils = import ../lib/utils.nix { lib = nixpkgs.lib; };

  inherit (utils)
    recImport
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

        local = import "${toString ./.}/${self}.nix";
      in
        [
          core
          global
          local
          home
        ];

    };

  hosts =
    recImport { dir = ./.; _import = config; };
in
hosts

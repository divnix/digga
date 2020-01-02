{ home, nixpkgs, flake, ... }:
let
  utils = import ../lib/utils.nix { lib = nixpkgs.lib; };

  inherit (utils)
    recImport
    ;

  inherit (builtins)
    attrValues
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

          nixpkgs.overlays = flake.overlays;
        };

        local = import "${toString ./.}/${self}.nix";

      in
        attrValues flake.nixosModules ++ [
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

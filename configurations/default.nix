{ nix, nixpkgs, flake, utils, ... }:
let
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
          _module.args.utils = utils;

          system.configurationRevision = flake.rev;

          networking.hostName = self;

          nix.package = nix.defaultPackage."${system}";
        };

        local = vimport ./. "${self}.nix";

      in
        [
          core
          global
          local
        ];

    };
in
  reqImport { dir = ./.; _import = config; }

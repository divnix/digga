{
  description = "DevOS environment configuriguration library.";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs";
      deploy = {
        url = "github:serokell/deploy-rs";
        inputs = {
          nixpkgs.follows = "nixpkgs";
          utils.follows = "utils";
        };
      };
      devshell.url = "github:numtide/devshell";
      utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
      nixlib.url = "github:divnix/nixpkgs.lib";

      # We only use the nixosModules output which only needs nixpkgs lib
      # TODO: don't pull another 'nixpkgs' when only nixpkgs lib is needed
      nixos-generators = {
        url = "github:nix-community/nixos-generators";
        inputs = {
          nixpkgs.follows = "nixpkgs";
          utils.follows = "utils";
        };
      };

    };

  outputs =
    { self
    , nixlib
    , nixpkgs
    , deploy
    , devshell
    , utils
    , nixos-generators
    , ...
    }@inputs:
    let
      lib = nixlib.lib.makeExtensible (self:
        let combinedLib = nixlib.lib // self; in
        with self;
        utils.lib // {
          attrs = import ./src/attrs.nix { lib = combinedLib; };
          lists = import ./src/lists.nix { lib = combinedLib; };
          strings = import ./src/strings.nix { lib = combinedLib; };

          modules = import ./src/modules.nix {
            lib = combinedLib;
            inherit nixos-generators;
          };

          importers = import ./src/importers.nix {
            lib = combinedLib;
          };

          generators = import ./src/generators.nix {
            lib = combinedLib;
            inherit deploy;
          };

          mkFlake = {
            __functor = import ./src/mkFlake { inherit deploy; lib = combinedLib; };
            evalArgs = import ./src/mkFlake/evalArgs.nix {
              lib = combinedLib;
              inherit devshell;
            };
          };

          pkgs-lib = import ./src/pkgs-lib {
            lib = combinedLib;
            inherit deploy devshell;
          };

          inherit (attrs) mapFilterAttrs genAttrs' concatAttrs;
          inherit (lists) unifyOverlays;
          inherit (strings) rgxToString;
          inherit (importers) profileMap flattenTree rakeLeaves mkProfileAttrs maybeImportDevshellModule;
          inherit (generators) mkSuites mkDeployNodes mkHomeConfigurations;
        }
      );

    in

    {
      lib = with lib; utils.lib // {
        inherit attrs lists modules importers generators;
        inherit (lib)
          mkFlake
          mkDeployNodes
          mkHomeConfigurations;
      };

      # digga-local use

      checks.x86_64-linux = import ./checks {
        inputs = { inherit nixpkgs lib; nixlib = nixlib.lib; };
        system = "x86_64-linux";
      };

      jobs.x86_64-linux = import ./jobs {
        inputs = { inherit nixpkgs; digga = self; };
        system = "x86_64-linux";
      };
    }

    //

    utils.lib.eachDefaultSystem (system: {
      devShell = import ./shell.nix {
        inputs = { inherit nixpkgs devshell; };
        inherit system;
      };
    });

}

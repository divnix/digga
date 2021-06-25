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
          tests = import ./src/tests.nix { lib = combinedLib; };

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

      # Unofficial Flakes Roadmap - Polyfills
      # .. see: https://demo.hedgedoc.org/s/_W6Ve03GK#
      # .. also: <repo-root>/ufr-polyfills

      # Super Stupid Flakes (ssf) / System As an Input - Style:
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin"];
      ufrContract = import ./ufr-polyfills/ufrContract.nix;

      # Dependency Groups - Style
      checksInputs = { inherit nixpkgs lib; nixlib = nixlib.lib; };
      jobsInputs = { inherit nixpkgs; digga = self; };
      devShellInputs = { inherit nixpkgs devshell; };

      # .. we hope you like this style.
      # .. it's adopted by a growing number of projects.
      # Please consider adopting it if you want to help to improve flakes.

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
      jobs =     ufrContract supportedSystems ./jobs      jobsInputs;
      checks =   ufrContract supportedSystems ./checks    checksInputs;
      devShell = ufrContract supportedSystems ./shell.nix devShellInputs;
    };

}

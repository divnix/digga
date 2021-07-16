{
  description = "DevOS environment configuriguration library.";

  nixConfig.extra-experimental-features = "nix-command flakes ca-references";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
      nixlib.follows = "nixpkgs"; # "github:nix-community/nixpkgs.lib";
      blank.url = "github:divnix/blank";
      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs.nixpkgs.follows = "nixpkgs";
      # deploy.inputs.utils.follows = "utils/flake-utils";

      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixlib";

      devshell.url = "github:numtide/devshell";
      utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";

      nixos-generators.url = "github:nix-community/nixos-generators";
      nixos-generators.inputs.nixpkgs.follows = "blank";
      nixos-generators.inputs.nixlib.follows = "nixlib";
      # nixos-generators.inputs.utils.follows = "utils/flake-utils";

      # start ANTI CORRUPTION LAYER
      # remove after https://github.com/NixOS/nix/pull/4641
      # and uncomment the poper lines using "utils/flake-utils" above
      flake-utils.url = "github:numtide/flake-utils";
      utils.inputs.flake-utils.follows = "flake-utils";
      deploy.inputs.utils.follows = "flake-utils";
      nixos-generators.inputs.utils.follows = "flake-utils";
      # end ANTI CORRUPTION LAYER
    };

  outputs =
    { self
    , nixlib
    , nixpkgs
    , deploy
    , devshell
    , utils
    , nixos-generators
    , home-manager
    , ...
    }@inputs:
    let

      lib = nixlib.lib.makeExtensible (self:
        let combinedLib = nixlib.lib // self; in
        with self;
        utils.lib // {
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
            __functor = import ./src/mkFlake {
              inherit deploy devshell home-manager;
              lib = combinedLib;
            };
            evalArgs = import ./src/mkFlake/evalArgs.nix {
              lib = combinedLib;
              inherit devshell;
            };
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
      # what you came for ...
      lib = let

        fupLib = with utils.lib; {

          inherit
           systemFlake
           exporters
           ;

        };

        diggaLib = with lib; {

          inherit
            modules
            importers
            ;

          inherit (lib)
            mkFlake
            mkDeployNodes
            mkHomeConfigurations
            ;

          inherit (lib.tests)
            mkTest
            ;

        };

      in fupLib // diggaLib;

      # a little extra service ...
      overlays = {
        patched = import ./patched;
      nixosModules = {
        nixConfig = lib.modules.nixConfig;
      };

      # digga-local use
      jobs =     ufrContract supportedSystems ./jobs      jobsInputs;
      checks =   ufrContract supportedSystems ./checks    checksInputs;
      devShell = ufrContract supportedSystems ./shell.nix devShellInputs;
    };

}

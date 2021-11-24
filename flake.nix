{
  description = "DevOS environment configuriguration library.";

  nixConfig.extra-experimental-features = "nix-command flakes ca-references";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
      latest.url = "github:nixos/nixpkgs/nixos-unstable";
      nixlib.follows = "nixpkgs"; # "github:nix-community/nixpkgs.lib";
      blank.url = "github:divnix/blank";
      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs.nixpkgs.follows = "latest";
      # deploy.inputs.utils.follows = "utils/flake-utils";

      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixlib";

      devshell.url = "github:numtide/devshell";
      # fork with urgent fixes that can't be added quickly upstream in respect of upstream user base
      flake-utils-plus.url = "github:divnix/flake-utils-plus";

      nixos-generators.url = "github:nix-community/nixos-generators";
      nixos-generators.inputs.nixpkgs.follows = "blank";
      nixos-generators.inputs.nixlib.follows = "nixlib";
      # nixos-generators.inputs.utils.follows = "utils/flake-utils";

      # start ANTI CORRUPTION LAYER
      # remove after https://github.com/NixOS/nix/pull/4641
      # and uncomment the poper lines using "utils/flake-utils" above
      flake-utils.url = "github:numtide/flake-utils";
      flake-utils-plus.inputs.flake-utils.follows = "flake-utils";
      deploy.inputs.utils.follows = "flake-utils";
      nixos-generators.inputs.utils.follows = "flake-utils";
      # end ANTI CORRUPTION LAYER
    };

  outputs =
    { self
    , nixlib
    , nixpkgs
    , latest
    , deploy
    , devshell
    , flake-utils-plus
    , nixos-generators
    , home-manager
    , ...
    }@inputs:
    let

      tests = import ./src/tests.nix { inherit (nixpkgs) lib; };

      internal-modules = import ./src/modules.nix {
        inherit (nixpkgs) lib;
        inherit nixos-generators;
      };

      importers = import ./src/importers.nix {
        inherit (nixpkgs) lib;
      };

      generators = import ./src/generators.nix {
        inherit (nixpkgs) lib;
        inherit deploy;
      };

      mkFlake =
        let
          mkFlake' = import ./src/mkFlake {
            inherit (nixpkgs) lib;
            inherit (flake-utils-plus.inputs) flake-utils;
            inherit deploy devshell home-manager flake-utils-plus internal-modules tests;
          };
        in
        {
          __functor = _: args: (mkFlake' args).flake;
          options = args: (mkFlake' args).options;
        };

      # Unofficial Flakes Roadmap - Polyfills
      # .. see: https://demo.hedgedoc.org/s/_W6Ve03GK#
      # .. also: <repo-root>/ufr-polyfills

      # Super Stupid Flakes (ssf) / System As an Input - Style:
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
      ufrContract = import ./ufr-polyfills/ufrContract.nix;

      # Dependency Groups - Style
      checksInputs = { inherit nixpkgs; digga = self; };
      jobsInputs = { inherit nixpkgs; digga = self; };
      devShellInputs = { inherit nixpkgs latest devshell; };

      # .. we hope you like this style.
      # .. it's adopted by a growing number of projects.
      # Please consider adopting it if you want to help to improve flakes.

      # DEPRECATED - will be removed timely
      deprecated = import ./deprecated.nix {
        inherit (nixpkgs) lib;
        inherit (self) nixosModules;
        inherit flake-utils-plus internal-modules importers;
      };

    in

    {
      # what you came for ...
      lib = {
        inherit (flake-utils-plus.inputs.flake-utils.lib) defaultSystems eachSystem eachDefaultSystem filterPackages;
        inherit (flake-utils-plus.lib) exportModules exportOverlays exportPackages;
        inherit mkFlake;
        inherit (tests) mkTest allProfilesTest;
        inherit (importers) flattenTree rakeLeaves importOverlays importExportableModules importHosts;
        inherit (generators) mkDeployNodes mkHomeConfigurations;

        # DEPRECATED - will be removed soon
        inherit (deprecated)
          mkSuites
          profileMap
          mkProfileAttrs
          exporters
          modules
          importModules
          importers
          ;

      };

      # a little extra service ...
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules;

      # digga-local use
      jobs = ufrContract supportedSystems ./jobs jobsInputs;
      checks = ufrContract supportedSystems ./checks checksInputs;
      devShell = ufrContract supportedSystems ./shell.nix devShellInputs;
    };

}

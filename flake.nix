{
  description = "DevOS environment configuriguration library.";

  inputs =
    {
      deploy.url = "github:serokell/deploy-rs";
      devshell.url = "github:numtide/devshell";
      utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
      nixlib.url = "github:divnix/nixpkgs.lib";

      # Only used for development
      nixpkgs.url = "github:nixos/nixpkgs";
    };

  outputs = inputs@{ self, nixlib, nixpkgs, deploy, devshell, utils, ... }:
    let
      lib = nixlib.lib.makeExtensible (self:
        let combinedLib = nixlib.lib // self; in
        with self;
        utils.lib // {
          attrs = import ./src/attrs.nix { lib = combinedLib; };
          lists = import ./src/lists.nix { lib = combinedLib; };
          strings = import ./src/strings.nix { lib = combinedLib; };
          modules = import ./src/modules.nix { lib = combinedLib; };

          importers = import ./src/importers.nix {
            lib = combinedLib;
            inherit devshell;
          };

          generators = import ./src/generators.nix {
            lib = combinedLib;
            inherit deploy;
          };

          mkFlake = {
            __functor = import ./src/mkFlake { lib = combinedLib; };
            evalArgs = import ./src/mkFlake/evalArgs.nix { lib = combinedLib; };
          };

          pkgs-lib = import ./src/pkgs-lib {
            lib = combinedLib;
            inherit deploy devshell;
          };

          inherit (attrs) mapFilterAttrs genAttrs' concatAttrs;
          inherit (lists) unifyOverlays;
          inherit (strings) rgxToString;
          inherit (importers) profileMap rakeLeaves mkProfileAttrs maybeImportDevshellModule;
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
    }

    //

    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        checks = import ./tests {
          pkgs = pkgs // {
            input = nixpkgs;
          };
          lib = nixlib.lib // lib;
        };

        devShell = lib.pkgs-lib.shell { inherit pkgs; };

        packages = {
          mkFlakeDoc = pkgs.writeText "mkFlakeOptions.md"
            (
              pkgs.nixosOptionsDoc {
                inherit (lib.mkFlake.evalArgs { args = { }; }) options;
              }
            ).optionsMDDoc;
        };
      }
    );

}

{
  description = "DevOS environment configuriguration library.";

  inputs =
    {
      deploy.url = "github:serokell/deploy-rs";
      devshell.url = "github:numtide/devshell";
      utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
    };

  outputs = inputs@{ self, nixpkgs, deploy, devshell, utils, ... }:
    let
      lib = nixpkgs.lib.makeExtensible (self:
        let combinedLib = nixpkgs.lib // self; in
        with self;
        utils.lib // {
          attrs = import ./src/attrs.nix { lib = combinedLib; };
          lists = import ./src/lists.nix { lib = combinedLib; };
          strings = import ./src/strings.nix { lib = combinedLib; };
          modules = import ./src/modules.nix { lib = combinedLib; };
          importers = import ./src/importers.nix { lib = combinedLib; };

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

          inherit (attrs) mapFilterAttrs genAttrs' safeReadDir concatAttrs;
          inherit (lists) profileMap collectProfiles unifyOverlays;
          inherit (strings) rgxToString;
          inherit (importers) mkProfileAttrs pathsIn importHosts;
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
        checks = {
          tests = import ./tests {
            inherit pkgs;
            lib = nixpkgs.lib // lib;
          };
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

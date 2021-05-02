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
          attrs = import ./attrs.nix { lib = combinedLib; };
          lists = import ./lists.nix { lib = combinedLib; };
          strings = import ./strings.nix { lib = combinedLib; };
          modules = import ./modules.nix { lib = combinedLib; };
          importers = import ./importers.nix { lib = combinedLib; };

          generators = import ./generators.nix {
            lib = combinedLib;
            inherit deploy;
          };

          mkFlake = {
            __functor = import ./mkFlake { lib = combinedLib; };
            evalArgs = import ./mkFlake/evalArgs.nix { lib = combinedLib; };
          };

          pkgs-lib = import ./pkgs-lib {
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
          pathsIn
          importHosts
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

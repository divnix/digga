{
  description = "DevOS environment configuriguration library.";

  inputs =
    {
      deploy.url = "github:serokell/deploy-rs";
      devshell.url = "github:numtide/devshell";
      utils.url = "github:numtide/flake-utils";
    };

  outputs = inputs@{ self, nixpkgs, deploy, devshell, utils, ... }:
    let

      lib = nixpkgs.lib.makeExtensible (self:
        let
          attrs = import ./attrs.nix { lib = nixpkgs.lib // self; };
          lists = import ./lists.nix { lib = nixpkgs.lib // self; };
          strings = import ./strings.nix { lib = nixpkgs.lib // self; };
          modules = import ./modules.nix { lib = nixpkgs.lib // self; };
        in

        utils.lib

        //

        {
          os = import ./devos {
            lib = nixpkgs.lib // self;
            inherit utils;
          };

          mkFlake = {
            __functor = import ./mkFlake {
              lib = nixpkgs.lib // self;
              inherit deploy;
            };
            evalArgs = import ./mkFlake/evalArgs.nix { lib = nixpkgs.lib // self; };
            evalOldArgs = import ./mkFlake/evalOldArgs.nix { lib = nixpkgs.lib // self; };
          };

          pkgs-lib = import ./pkgs-lib {
            lib = nixpkgs.lib // self;
            inherit nixpkgs deploy devshell;
          };

          inherit (attrs)
            mapFilterAttrs
            genAttrs'
            safeReadDir
            pathsToImportedAttrs
            concatAttrs
            filterPackages;
          inherit (lists) pathsIn collectProfiles;
          inherit (strings) rgxToString;
          inherit modules;
        }
      );

    in

    {
      lib = utils.lib // {
        inherit (lib)
          mkFlake;
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
                inherit (lib.mkFlake.evalArgs { nixos = "nixos"; args = { }; }) options;
              }
            ).optionsMDDoc;
        };
      }
    );

}

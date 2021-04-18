{
  description = "DevOS environment configuriguration library.";

  inputs =
    {
      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs = {
        utils.follows = "utils";
      };
      devshell.url = "github:numtide/devshell";
      utils.url = "github:numtide/flake-utils";
      
    };

  outputs = inputs@{ self, nixpkgs, deploy, devshell, utils, ... }: let

    inherit (nixpkgs) lib;

    # We work with a combined lib, internally ...
    combinedLib = lib.extend (final: prev:
      let callLibs = file: import file
        ({
          lib = final;
          userFlakeNixos = {};
          userFlakeSelf = {};
          userFlakeInputs = {}; # TODO: Erm, theese must become proper arguments to mkFlake
        } // inputs);
      in
      with final;
      let

        attrs = import ./attrs.nix { lib = prev; };
        lists = import ./lists.nix { lib = prev; };
        strings = import ./strings.nix { lib = prev; };
      in

      utils.lib

      //

      {
        inherit callLibs;

        os = import ./devos { lib = final; };

        mkFlake = {
          __functor = callLibs ./mkFlake;
          evalArgs = callLibs ./mkFlake/evalArgs.nix;
          evalOldArgs = callLibs ./mkFlake/evalOldArgs.nix;
        };

        pkgs-lib = import ./pkgs-lib {
          lib = final;
          inherit nixpkgs deploy devshell;
        };

        inherit (attrs) mapFilterAttrs genAttrs' safeReadDir
          pathsToImportedAttrs concatAttrs filterPackages;
        inherit (lists) pathsIn;
        inherit (strings) rgxToString;
      }
    );

  in

  {

    # ... but don't force that choice onto the user
    lib = utils.lib // {
      mkFlake = combinedLib.mkFlake;
      pkgs-lib = combinedLib.pkgs-lib;
    };

  }

  //

  utils.lib.eachDefaultSystem (system:
    let
      nixpkgs' = import nixpkgs { inherit system; overlays = []; config = {}; };
    in
      {
        checks = {
          tests = import ./tests {
            inherit (nixpkgs') pkgs;
            lib = combinedLib;
          };
        };
      }
  );

}

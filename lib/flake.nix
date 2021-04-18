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
          userFlakeInputs = {}; # TODO: Erm, this must become a proper argument to mkFlake
        } // inputs);
      in
      with final;
      let
        attrs = callLibs ./attrs.nix;
        lists = callLibs ./lists.nix;
        strings = callLibs ./strings.nix;
      in
      {
        inherit callLibs;

        os = callLibs ./devos;

        mkFlake = {
          __functor = callLibs ./mkFlake;
          evalArgs = callLibs ./mkFlake/evalArgs.nix;
          evalOldArgs = callLibs ./mkFlake/evalOldArgs.nix;
        };

        pkgs-lib = callLibs ./pkgs-lib;

        inherit (attrs) mapFilterAttrs genAttrs' safeReadDir
          pathsToImportedAttrs concatAttrs filterPackages;
        inherit (lists) pathsIn;
        inherit (strings) rgxToString;
      });

  in

  {

    # ... but don't force that choice onto the user
    lib = {
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

{
  description = "DevOS environment configuriguration library.";

  inputs =
    {
      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs = {
        utils.follows = "flake-utils";
      };
      devshell.url = "github:numtide/devshell";
      flake-utils.url = "github:numtide/flake-utils";
      
    };

  outputs = inputs@{ self, nixpkgs, deploy, devshell, flake-utils, ... }: let

    inherit (nixpkgs) lib;

    # We work with a combined lib, internally ...
    combinedLib = lib.extend (final: prev:
      let callLibs = file: import file
        ({
          lib = final;
          dev = final;
          inputs = inputs;
        } // inputs);
      in
      with final;
      {
        inherit callLibs;

        attrs = callLibs ./attrs.nix;
        os = callLibs ./devos;
        lists = callLibs ./lists.nix;
        strings = callLibs ./strings.nix;

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

  in {

    # ... but don't force that choice onto the user
    lib = {
      mkFlake = combinedLib.mkFlake;
      pkgs-lib = combinedLib.pkgs-lib;
    };


    checks = flake-utils.lib.eachDefaultSystem (system: let
      nixpkgs = import nixpkgs { inherit system; overlays = []; config = {}; };
    in
      {
        tests = import ./tests {
          inherit (nixpkgs) pkgs;
          inherit (self) lib;
        };
      }
    );
  };

}

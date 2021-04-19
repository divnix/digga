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

    lib = nixpkgs.lib.makeExtensible (self:
      let
        callLibs = file: import file
          ({
            lib = self;
            userFlakeNixos = {};
            userFlakeSelf = {};
            userFlakeInputs = {}; # TODO: Erm, theese must become proper arguments to mkFlake
          } // inputs);

        attrs = import ./attrs.nix { lib = nixpkgs.lib // self; };
        lists = import ./lists.nix { lib = nixpkgs.lib // self; };
        strings = import ./strings.nix { lib = nixpkgs.lib // self; };
      in

      utils.lib

      //

      {
        os = import ./devos {
          lib = nixpkgs.lib // self;
          inherit utils;
        };

        mkFlake = {
          __functor = callLibs ./mkFlake;
          evalArgs = callLibs ./mkFlake/evalArgs.nix;
          evalOldArgs = callLibs ./mkFlake/evalOldArgs.nix;
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
        inherit (lists) pathsIn;
        inherit (strings) rgxToString;
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
      nixpkgs' = import nixpkgs { inherit system; overlays = []; config = {}; };
    in
      {
        checks = {
          tests = import ./tests {
            inherit (nixpkgs') pkgs;
            lib = nixpkgs.lib // lib;
          };
        };
      }
  );

}

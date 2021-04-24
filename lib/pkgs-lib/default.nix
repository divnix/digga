{ lib, nixpkgs, deploy, devshell }:

lib.genAttrs
  lib.defaultSystems
  (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      tests = import ./tests { inherit lib deploy nixpkgs pkgs system; };
      shell = import ./shell { inherit lib devshell deploy nixpkgs system; };
    }
  )

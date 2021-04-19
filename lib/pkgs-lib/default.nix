{ lib, nixpkgs, deploy, devshell }:

lib.genAttrs
  lib.defaultSystems (system:
    {
      tests = import ./tests { inherit lib deploy nixpkgs pkgs system; };
      shell = import ./shell { inherit lib devshell deploy nixpkgs system; };
    }
  )

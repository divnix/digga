{
  description = "Digga Library Jobs";

  inputs = {
    digga.url = "path:../";
    digga.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, digga }: let

    # Unofficial Flakes Roadmap - Polyfills
    # .. see: https://demo.hedgedoc.org/s/_W6Ve03GK#
    # .. also: <repo-root>/ufr-polyfills

    # Super Stupid Flakes / System As an Input - Style:
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin"];
    ufrContract = import ../ufr-polyfills/ufrContract.nix;

    # Dependency Groups - Style
    jobsInputs = { inherit nixpkgs digga; };

    # .. we hope you like this style.
    # .. it's adopted by a growing number of projects.
    # Please consider adopting it if you want to help to improve flakes.

  in
  {

    jobs = ufrContract supportedSystems ./. jobsInputs;

  };
}

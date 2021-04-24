{ nixpkgs, lib, system ? "x86_64-linux" }:
let
  pkgs = import nixpkgs { inherit system; overlays = [ ]; config = { }; };
in
{
  mkFlakeDoc = import ./mkFlakeDoc.nix { inherit pkgs lib; };
}

let
  nixpkgs = import ./compat/nixpkgs.nix;
  fetch = import ./compat/fetch.nix;

  devshell' = fetch "devshell";
  pkgs' = import devshell' { inherit nixpkgs; };
in
{ pkgs ? pkgs', ... }: pkgs.mkDevShell {
  imports  = [ (import ./shells/flk) ];
}

let
  nixpkgs = import ./compat/nixpkgs.nix;
  fetch = import ./compat/fetch.nix;

  devshell' = fetch "devshell";
  pkgs' = import devshell' { inherit nixpkgs; };
in
{ pkgs ? pkgs', ... }:
let
  configs = "${toString ./.}#nixosConfigurations";
  build = "config.system.build";

  installPkgs = (import "${nixpkgs}/nixos" {
    configuration = { };
    system = pkgs.system;
  }).config.system.build;

  flk = pkgs.writeShellScriptBin "flk" ''
    if [[ -z $1 ]]; then
      echo "Usage: $(basename $0) [ iso | install {host} | {host} [switch|boot|test] ]"
    elif [[ $1 == "iso" ]]; then
      nix build ${configs}.niximg.${build}.isoImage
    elif [[ $1 == "install" ]]; then
      sudo nixos-install --flake ".#$2" "${"\${@:3}"}"
    else
      sudo nixos-rebuild --flake ".#$1" "${"\${@:2}"}"
    fi
  '';

  nix = pkgs.writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
  '';
in
pkgs.mkDevShell {
  name = "nixflk";

  packages = with pkgs; with installPkgs; [
    git
    git-crypt
    flk
    nix
    nixpkgs-fmt
    python38Packages.grip
    nixos-install
    nixos-generate-config
    nixos-enter
    nixos-rebuild
  ];

  env = { };

}

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
    if [[ -z "$1" || "$1" == "help" || "--help" || "-h" ]]; then
      echo "Usage: $(basename "$0") [ iso | install {host} | {host} [switch|boot|test] ]"
    elif [[ "$1" == "iso" ]]; then
      nix build ${configs}.niximg.${build}.isoImage
    elif [[ "$1" == "install" ]]; then
      sudo nixos-install --flake ".#$2" "${"\${@:3}"}"
    else
      sudo nixos-rebuild --flake ".#$1" "${"\${@:2}"}"
    fi
  '';

  name = "flk";
in
pkgs.mkDevShell {

  imports  = [ (import ./shells/rust) ];
  nixflk.rust.enable = true;
  
  inherit name;

  packages = with pkgs; with installPkgs; [
    git-crypt
    nixos-install
    nixos-generate-config
    nixos-enter
  ];

  env = { inherit name; };

  commands = with pkgs; [
    {
      name = nixpkgs-fmt.pname;
      package = nixpkgs-fmt;
      help = nixpkgs-fmt.meta.description;
      category = "linters";
    }
    {
      name = flk.name;
      help = "Build, deploy, and install nixflk";
      category = "main";
      package = flk;
    }
    {
      name = "grip";
      help = python38Packages.grip.meta.description;
      category = "servers";
      package = python38Packages.grip;
    }
    {
      name = git.pname;
      help = git.meta.description;
      category = "vcs";
      package = git;
    }
    {
      name = "nix";
      help = nixFlakes.meta.description;
      category = "main";
      command = ''${nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"'';
    }
  ];

}

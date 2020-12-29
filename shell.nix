let
  nixpkgs = import ./compat/nixpkgs.nix;
in
{ pkgs ? import nixpkgs { }, nixpkgs ? nixpkgs' }:
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
      nixos-install --flake ".#$2" $@
    else
      sudo nixos-rebuild --flake ".#$1" $@
    fi
  '';
in
pkgs.mkShell {
  name = "nixflk";
  nativeBuildInputs = with pkgs; with installPkgs; [
    git
    git-crypt
    flk
    nix-zsh-completions
    python38Packages.grip
    nixos-install
    nixos-generate-config
    nixos-enter
    nixos-rebuild
  ];

  shellHook = ''
    mkdir -p secrets
    if ! nix flake show &> /dev/null; then
      PATH=${
        pkgs.writeShellScriptBin "nix" ''
          ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
        ''
      }/bin:$PATH
    fi
  '';
}

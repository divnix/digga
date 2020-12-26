{ pkgs ? import <nixpkgs> {
    overlays = [ (import ./overlays/nix-zsh-completions.nix) ];
  }
}:
let
  configs = "${toString ./.}#nixosConfigurations";
  build = "config.system.build";

  flk = pkgs.writeShellScriptBin "flk" ''
    if [[ -z $1 ]]; then
      echo "Usage: $(basename $0) host {switch|boot|test|iso}"
    elif [[ $1 == "iso" ]]; then
      nix build ${configs}.niximg.${build}.isoImage
    else
      sudo nixos-rebuild --flake ".#$1" $2
    fi
  '';
in
pkgs.mkShell {
  name = "nixflk";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    flk
    nix-zsh-completions
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

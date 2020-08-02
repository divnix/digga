{ pkgs ? import <nixpkgs> { } }:
let
  configs = "${toString ./.}#nixosConfigurations";
  hostname = pkgs.lib.fileContents /etc/hostname;
  build = "config.system.build";

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    if [[ -z $1 ]]; then
      echo "Usage: $0 [host] {switch|boot|test|iso}"
    elif [[ $1 == "iso" ]]; then
      nix build ${configs}.niximg.${build}.isoImage
    elif [[ -z $2 ]]; then
      sudo -E nix shell -vv ${configs}.${hostname}.${build}.toplevel -c switch-to-configuration $1
    else
      sudo -E nix shell -vv ${configs}.$1.${build}.toplevel -c switch-to-configuration $2
    fi
  '';
in
pkgs.mkShell {
  name = "nixflk";
  nativeBuildInputs = with pkgs; [ git git-crypt nixFlakes rebuild ];

  shellHook = ''
    mkdir -p secrets
    PATH=${
      pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
      ''
    }/bin:$PATH
  '';
}

{ pkgs ? import <nixpkgs> { } }:
let
  configs = "${toString ./.}#nixosConfigurations";

  buildIso = pkgs.writeShellScriptBin "build-iso" ''
    nix build ${configs}.niximg.config.system.build.isoImage $@
  '';
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ git git-crypt nixFlakes buildIso ];

  shellHook = ''
    mkdir -p secrets
    PATH=${
      pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" $@
      ''
    }/bin:$PATH
  '';
}

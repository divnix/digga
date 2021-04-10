{ lib, dev, inputs, system, nixos, ... }:
let
  overlays = [
    inputs.devshell.overlay
    (final: prev: {
      deploy-rs =
        inputs.deploy.packages.${prev.system}.deploy-rs;
    })
  ];

  pkgs = dev.os.pkgImport nixos overlays system;

  flk = pkgs.callPackage ./flk.nix { };

  installPkgs = (lib.nixosSystem {
    inherit system;
    modules = [ ];
  }).config.system.build;
in
pkgs.devshell.mkShell {
  imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];

  packages = with installPkgs; [
    nixos-install
    nixos-generate-config
    nixos-enter
  ];

  git.hooks = {
    pre-commit.text = lib.fileContents ./pre-commit.sh;
  };

  commands = with pkgs; [
    { package = flk; }
    {
      name = "nix";
      help = pkgs.nixFlakes.meta.description;
      command = ''
        ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes ca-references" "${"\${@}"}"
      '';
    }
  ]
  ++ lib.optional (system != "i686-linux") { package = cachix; }
  ++ lib.optional (system == "x86_64-linux") {
    name = "deploy";
    package = deploy-rs;
    help = "A simple multi-profile Nix-flake deploy tool.";
  };
}

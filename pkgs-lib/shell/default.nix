{ lib, devshell, deploy }:

{ pkgs }:
let
  overlays = [
    devshell.overlay

    (final: prev: {
      deploy-rs =
        deploy.packages.${prev.system}.deploy-rs;
    })

    (final: prev: {
      nixos-rebuild = prev.nixos-rebuild.override {
        nix = prev.nixFlakes;
      };
    })
  ];

  pkgs' = pkgs.appendOverlays overlays;

  flk = pkgs'.callPackage ./flk.nix { };

  installPkgs = (lib.nixosSystem {
    inherit (pkgs') system;
    modules = [ ];
  }).config.system.build;

  # Add all packages from overlays to shell
  # Follow same logic as exporting packages except don't filter out inputs
  allOverlays = lib.exporter.overlaysFromChannelsExporter {
    # function requires system-spaced and channel-spaced package set
    pkgs.${pkgs'.system}.channel = pkgs';
  };
  customPackages = lib.builder.packagesFromOverlaysBuilderConstructor allOverlays { pkgs = pkgs'; };

in
pkgs'.devshell.mkShell {
  imports = [ (pkgs'.devshell.importTOML ./devshell.toml) ];

  packages = with installPkgs; [
    nixos-install
    nixos-generate-config
    nixos-enter
    pkgs'.nixos-rebuild
  ] ++ (builtins.attrValues customPackages);

  git.hooks = {
    pre-commit.text = lib.fileContents ./pre-commit.sh;
  };

  commands = with pkgs'; [
    { package = flk; }
    {
      name = "nix";
      help = pkgs'.nixFlakes.meta.description;
      command = ''
        ${pkgs'.nixFlakes}/bin/nix --experimental-features "nix-command flakes ca-references" "${"\${@}"}"
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

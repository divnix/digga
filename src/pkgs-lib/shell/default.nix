{ lib, devshell, deploy }:

{ pkgs, extraModules ? [ ] }:
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

  installPkgs = (import "${toString pkgs.path}/nixos/lib/eval-config.nix" {
    inherit (pkgs') system;
    modules = [ ];
  }).config.system.build;


  configuration = {
    imports = [ (pkgs'.devshell.importTOML ./devshell.toml) ]
      ++ (map lib.maybeImportDevshellModule extraModules);

    packages = with installPkgs; [
      nixos-install
      nixos-generate-config
      nixos-enter
      pkgs'.nixos-rebuild
      pkgs'.fup-repl
    ];

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
      {
        name = "deploy";
        package = deploy-rs;
        help = "A simple multi-profile Nix-flake deploy tool.";
      }
    ]
    ++ lib.optional (system != "i686-linux") { package = cachix; };
  };
in
pkgs'.devshell.mkShell configuration

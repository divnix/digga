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

  # Add all packages from overlays to shell
  # Follow same logic as exporting packages except don't filter out inputs
  allOverlays = lib.exporters.internalOverlays {
    # function requires system-spaced and channel-spaced package set
    pkgs.${pkgs'.system}.channel = pkgs';
  };
  customPackages = lib.exporters.fromOverlays allOverlays { pkgs = pkgs'; };

  configuration = {
    imports = [ (pkgs'.devshell.importTOML ./devshell.toml) ] ++ extraModules;

    packages = with installPkgs; [
      nixos-install
      nixos-generate-config
      nixos-enter
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
  };
in
(pkgs'.devshell.eval {
  inherit configuration;
  # Allows us to use devshell's `importTOML` within a module
  # used in evalArgs to auto-import toml files
  extraSpecialArgs.pkgs = pkgs';
}).shell

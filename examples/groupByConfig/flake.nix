{
  description = "A DevOS example. And also a digga test bed.";

  inputs = {
    # Track channels with commits tested and built by hydra
    nixos.url = "github:nixos/nixpkgs/nixos-21.11";

    # For darwin hosts: it can be helpful to track this darwin-specific stable
    # channel equivalent to the `nixos-*` channels for NixOS. For one, these
    # channels are more likely to provide cached binaries for darwin systems.
    # But, perhaps even more usefully, it provides a place for adding
    # darwin-specific overlays and packages which could otherwise cause build
    # failures on Linux systems.
    nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-21.11-darwin";

    digga = {
      # TODO: revert before merging
      url = "github:divnix/digga/darwin-support";
      inputs.nixpkgs.follows = "nixos";
    };

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

    home.url = "github:nix-community/home-manager/release-21.11";
    home.inputs.nixpkgs.follows = "nixos";
  };

  outputs =
    inputs @ { self
    , nixos
    , nixpkgs
    , nixpkgs-darwin-stable
    , darwin
    , digga
    , home
    , ...
    }:
    digga.lib.mkFlake {

      inherit self inputs;

      channels = {
        nixos = { };
        nixpkgs-darwin-stable = { };
      };

      nixos = ./nixos;
      darwin = ./darwin;
      home = ./home;
      devshell = ./devshell;

    };
}

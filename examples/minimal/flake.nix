{
  description = "A minimal Digga NixOS configuration.";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://nrdxp.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    blank.url = "github:divnix/blank";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixpkgs";
    digga.inputs.nixlib.follows = "nixpkgs";
    digga.inputs.home-manager.follows = "home-manager";
    digga.inputs.darwin.follows = "blank";
    digga.inputs.deploy.follows = "blank";
    digga.inputs.flake-compat.follows = "blank";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    digga,
    ...
  } @ inputs:
    digga.lib.mkFlake
    {
      inherit self inputs;

      channels = {
        nixpkgs = {};
      };

      nixos = {
        imports = [(digga.lib.importHosts ./hosts)];
        importables = rec {
          profiles =
            digga.lib.rakeLeaves ./profiles
            // {
              users = digga.lib.rakeLeaves ./users;
            };
          suites = with profiles; rec {
            base = [cachix users.nixos users.root];
          };
        };
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixpkgs";
          imports = [(digga.lib.importExportableModules ./modules)];
          modules = [
            {lib.our = self.lib;}
            digga.nixosModules.nixConfig
            home-manager.nixosModules.home-manager
          ];
        };
        hosts = {
          NixOS = {};
        };
      };

      home = {
        imports = [(digga.lib.importExportableModules ./home/modules)];
        modules = [];
        importables = rec {
          profiles = digga.lib.rakeLeaves ./home/profiles;
          suites = with profiles; rec {
            base = [direnv git];
          };
        };
        users = {
          nixos = {suites, ...}: {
            imports = suites.base;

            home.stateVersion = "22.11";
          };
        };
      };

      devshell.exportedModules = [
        (
          {pkgs, ...}: {
            commands = [
              {
                package = pkgs.nixUnstable;
              }
            ];
          }
        )
      ];

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;
    };
}

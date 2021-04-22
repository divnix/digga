{
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-unstable";
      latest.url = "nixpkgs";
      devos.url = "path:./lib"; # TODO: outfactor into separate repo
      devos.inputs = {
        nixpkgs.follows = "nixos";
        # deploy.inputs = {
        #   flake-compat.follows = "flake-compat";
        #   naersk.follows = "naersk";
        #   nixpkgs.follows = "nixos";
        # };
      };

      ci-agent = {
        url = "github:hercules-ci/hercules-ci-agent";
        inputs = { nix-darwin.follows = "darwin"; flake-compat.follows = "flake-compat"; nixos-20_09.follows = "nixos"; nixos-unstable.follows = "latest"; };
      };
      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";
      flake-compat.url = "github:BBBSnowball/flake-compat/pr-1";
      flake-compat.flake = false;
      home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";
      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "latest";
      nixos-hardware.url = "github:nixos/nixos-hardware";

      pkgs.url = "path:./pkgs";
      pkgs.inputs.nixpkgs.follows = "nixos";
    };

  outputs = inputs@{ self, pkgs, devos, nixos, ci-agent, home, nixos-hardware, nur, ... }:
    devos.lib.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      channels = {
        nixos = {
          overlays = nixos.lib.flatten [
            (devos.lib.pathsIn ./overlays)
            pkgs.overlay
            ./overrides.nix # from "latest" channel
            nur.overlay
          ];
        };
        latest = { };
      };

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          modules = ./modules/module-list.nix;
          externalModules = [
            ci-agent.nixosModules.agent-profile
            home.nixosModules.home-manager
          ];
        };
        hosts = {
          NixOS = {
            modules = ./hosts/NixOS.nix;
          };
        };
        profiles = [ ./profiles ./users ];
        suites = { profiles, users, ... }: with profiles; {
          base = [ core users.nixos users.root ];
        };
      };

      home = {
        modules = ./users/modules/module-list.nix;
        externalModules = [ ];
        profiles = [ ./users/profiles ];
        suites = { profiles, ... }: with profiles; {
          base = [ direnv git ];
        };
      };

      #defaultTemplate = self.templates.flk;
      templates.flk.path = ./.;
      templates.flk.description = "flk template";

    }
  ;
}

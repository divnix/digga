{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs =
    {
      # Track channels with commits tested and built by hydra
      nixos.url = "github:nixos/nixpkgs/nixos-21.11";
      latest.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-21.11-darwin";

      digga.url = "github:divnix/digga/darwin-support";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      # digga.inputs.darwin.follows = "darwin";
      digga.inputs.home-manager.follows = "home";
      digga.inputs.deploy.follows = "deploy";

      bud.url = "github:divnix/bud";
      bud.inputs.nixpkgs.follows = "nixos";
      bud.inputs.devshell.follows = "digga/devshell";

      home.url = "github:nix-community/home-manager/release-21.11";
      home.inputs.nixpkgs.follows = "nixos";

      # TODO: update url once https://github.com/LnL7/nix-darwin/pull/429 is merged
      darwin.url = "github:montchr/nix-darwin/add-toplevel-option-lib";
      darwin.inputs.nixpkgs.follows = "nixos";

      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs.nixpkgs.follows = "nixos";

      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixos";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "nixos";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "nixos";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      nixos-generators.url = "github:nix-community/nixos-generators";
    };

  outputs =
    { self
    , digga
    , bud
    , nixos
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , nixpkgs
    , ...
    } @ inputs:
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        channels =
          let
            # TODO: any reason to avoid applying these to `latest` via `sharedOverlays`?
            commonOverlays = [
              nur.overlay
              agenix.overlay
              nvfetcher.overlay
              ./pkgs/default.nix
            ];
          in
          {
            nixos = {
              imports = [ (digga.lib.importOverlays ./overlays) ];
              overlays = commonOverlays ++ [ ];
            };
            nixpkgs-darwin = {
              imports = [ (digga.lib.importOverlays ./overlays) ];
              overlays = commonOverlays ++ [
                # TODO: create if necessary -- or perhaps a placeholder for both host types
                # ./pkgs/darwin
              ];
            };
            latest = { };
          };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
            });
          })
        ];

        nixos = {
          hostDefaults = {
            system = "x86_64-linux";
            channelName = "nixos";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              home.nixosModules.home-manager
              agenix.nixosModules.age
              bud.nixosModules.bud
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts/nixos) ];
          hosts = {
            /* set host-specific properties here */
            NixOS = { };
          };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [ core.nixos users.nixos users.root ];
            };
          };
        };

        darwin = {
          hostDefaults = {
            system = "x86_64-darwin";
            channelName = "nixpkgs-darwin";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              { lib.our = self.lib; }
              digga.darwinModules.nixConfig
              home.darwinModules.home-manager
              agenix.nixosModules.age
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts/darwin) ];
          hosts = {
            /* set host-specific properties here */
            Mac = { };
          };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              base = [ core.darwin users.darwin ];
            };
          };
        };

        home = {
          imports = [ (digga.lib.importExportableModules ./users/modules) ];
          modules = [ ];
          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ direnv git ];
            };
          };
          users = {
            # TODO: does this naming convention still make sense with darwin support?
            #
            # - it doesn't make sense to make a 'nixos' user available on
            #   darwin, and vice versa
            #
            # - the 'nixos' user might have special significance as the default
            #   user for fresh systems
            #
            # - perhaps a system-agnostic home-manager user is more appropriate?
            #   something like 'primaryuser'?
            #
            # all that said, these only exist within the `hmUsers` attrset, so
            # it could just be left to the developer to determine what's
            # appropriate. after all, configuring these hm users is one of the
            # first steps in customizing the template.
            nixos = { suites, ... }: { imports = suites.base; };
            darwin = { suites, ... }: { imports = suites.base; };
          }; # digga.lib.importers.rakeLeaves ./users/hm;
        };

        devshell = ./shell;

        # TODO: similar to the above note: does it make sense to make all of
        # these users available on all systems?
        homeConfigurations = digga.lib.mergeAny
          (digga.lib.mkHomeConfigurations self.darwinConfigurations)
          (digga.lib.mkHomeConfigurations self.nixosConfigurations)
        ;

        # TODO: does it make sense to include `darwinConfigurations`? i assume no.
        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

      }
  ;
}

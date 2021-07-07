{
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/release-21.05";
      latest.url = "nixpkgs";
      digga = {
        url = "github:divnix/digga/develop";
        inputs.nipxkgs.follows = "latest";
        inputs.deploy.follows = "deploy";
      };
      bud.url = "github:divnix/bud"; # no need to follow nixpkgs: it never materialises
      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs.nixpkgs.follows = "nixos";

      # remove after https://github.com/NixOS/nix/pull/4641
      nixpkgs.follows = "nixos";

      ci-agent = {
        url = "github:hercules-ci/hercules-ci-agent";
        inputs = { nix-darwin.follows = "darwin"; nixos-20_09.follows = "nixos"; nixos-unstable.follows = "latest"; };
      };
      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";
      home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";
      # naersk.url = "github:nmattia/naersk";
      # naersk.inputs.nixpkgs.follows = "latest";
      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "latest";
      nixos-hardware.url = "github:nixos/nixos-hardware";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "latest";
    };

  outputs =
    { self
    , digga
    , bud
    , nixos
    , ci-agent
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , ...
    } @ inputs:
    let
      bud' = bud self; # rebind to access self.budModules
    in
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      channels = {
        nixos = {
          imports = [ (digga.lib.importers.overlays ./overlays) ];
          overlays = [
            nur.overlay
            agenix.overlay
            nvfetcher.overlay
            deploy.overlay
            ./pkgs/default.nix
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
          imports = [ (digga.lib.importers.modules ./modules) ];
          externalModules = [
            { lib.our = self.lib; }
            ci-agent.nixosModules.agent-profile
            home.nixosModules.home-manager
            agenix.nixosModules.age
            (bud.nixosModules.bud bud')
          ];
        };

        imports = [ (digga.lib.importers.hosts ./hosts) ];
        hosts = {
          /* set host specific properties here */
          NixOS = { };
        };
        importables = rec {
          profiles = digga.lib.importers.rakeLeaves ./profiles // {
            users = digga.lib.importers.rakeLeaves ./users;
          };
          suites = with profiles; rec {
            base = [ core users.nixos users.root ];
          };
        };
      };

      home = {
        imports = [ (digga.lib.importers.modules ./users/modules) ];
        externalModules = [ ];
        importables = rec {
          profiles = digga.lib.importers.rakeLeaves ./users/profiles;
          suites = with profiles; rec {
            base = [ direnv git ];
          };
        };
      };

      devshell.modules = [ (import ./shell bud') ];

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

      defaultTemplate = self.templates.bud;
      templates.bud.path = ./.;
      templates.bud.description = "bud template";

    }
    //
    {
      budModules = { devos = import ./pkgs/bud; };
    }
  ;
}

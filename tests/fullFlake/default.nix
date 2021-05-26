{ pkgs, lib }:
let
  self = lib.mkFlake {

    self = self // {
      outPath = toString ./.;
    };

    inputs = {
      nixos = pkgs.input;
      latest = pkgs.input;
    };

    channelsConfig = { allowUnfree = true; };

    channels = {
      nixos = {
        imports = [ (lib.importers.overlays ./overlays) ];
      };
      latest = { };
    };

    lib = lib.makeExtensible (self: { });

    outputsBuilder = channels: {
      checks = {
        hostBuild = self.nixosConfigurations.NixOS.config.system.build.toplevel;
      };
    };

    sharedOverlays = [
      (final: prev: {
        ourlib = self.lib;
      })
    ];

    devshell.modules = [ ./devshell.toml ];

    nixos = {
      hostDefaults = {
        system = "x86_64-linux";
        channelName = "nixos";
        modules = ./modules/module-list.nix;
        externalModules = [
          { _module.args.ourlib = self.lib; }
          ./modules/customBuilds.nix
        ];
      };

      imports = [ (lib.importers.hosts ./hosts) ];
      hosts = {
        /* set host specific properties here */
        NixOS = { };
      };
      importables = rec {
        profiles = lib.importers.rakeLeaves ./profiles // {
          users = lib.importers.rakeLeaves ./users;
        };
        suites = with profiles; {
          base = [ cachix core users.nixos users.root ];
        };
      };
    };

    home = {
      modules = ./users/modules/module-list.nix;
      externalModules = [ ];
      importables = rec {
        profiles = lib.importers.rakeLeaves ./profiles;
        suites = with profiles; {
          base = [ direnv git ];
        };
      };
    };

    deploy.nodes = lib.mkDeployNodes self.nixosConfigurations { };

    #defaultTemplate = self.templates.flk;
    templates.flk.path = ./.;
    templates.flk.description = "flk template";
  };
in
self

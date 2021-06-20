{ pkgs, lib }:
let
  self = lib.mkFlake {

    self = self // {
      outPath = toString ./.;
      inputs = {
        nixos = pkgs.input;
        latest = pkgs.input;
      };
    };

    channelsConfig = { allowUnfree = true; };

    channels = {
      nixos = {
        imports = [ (lib.importers.overlays ./overlays) ];
        overlays = [
          # mimicing an external overlay
          (final: prev: { i-do-exists-before-local-overlays-accessor-me = prev.hello; })
        ];
      };
      latest = { };
    };

    lib = lib.makeExtensible (self: { });

    outputsBuilder = channels: {
      checks = {
        hostBuild = assert self.nixosConfigurations ? "com.example.myhost";
          self.nixosConfigurations.NixOS.config.system.build.toplevel;
        overlays-order = channels.nixos.pkgs.i-was-accessed-without-error;
        # At least check that those build.
        # They are usually tested against additional checks with
        nixosModules = self.nixosModules;

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
        imports = [ (lib.importers.modules ./modules) ];
        externalModules = [
          { lib.our = self.lib; }
          ./modules/customBuilds.nix # avoid exporting
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
      imports = [ (lib.importers.modules ./user/modules) ];
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

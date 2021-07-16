{ lib, nixos-generators }:
{
  customBuilds =
    { lib, pkgs, config, baseModules, modules, ... }@args:
    {
      # created in modules system for access to specialArgs and modules
      lib.digga.mkBuild = buildModule:
        import "${toString pkgs.path}/nixos/lib/eval-config.nix" {
          inherit (pkgs) system;
          inherit baseModules;
          modules = modules ++ [ buildModule ];
          # Newer versions of module system pass specialArgs to modules
          # so try to pass that to eval if possible.
          specialArgs = args.specialArgs or { };
        };
      system.build =
        let
          builds = lib.mapAttrs
            (format: module:
              let build = config.lib.digga.mkBuild module; in
              build // build.config.system.build.${build.config.formatAttr}
            )
            nixos-generators.nixosModules;
        in
        # ensure these builds can be overriden by other modules
        lib.mkBefore builds;
    };

  hmNixosDefaults = { specialArgs, modules }:
    { options, ... }: {
      config = lib.optionalAttrs (options ? home-manager) {
        home-manager = {
          # always use the system nixpkgs from the host's channel
          useGlobalPkgs = true;
          # and use the possible future default (see manual)
          useUserPackages = lib.mkDefault true;

          extraSpecialArgs = specialArgs;
          sharedModules = modules;
        };
      };
    };

  nixConfig =
    let

      experimental-features = [
        "flakes"
        "nix-command"
        "ca-references"
      ];
      substituters = [
        "https://nrdxp.cachix.org" # quality of life cache from our CI
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

    in
    {

      # package and option is from fup
      nix.generateRegistryFromInputs = lib.mkDefault true;

      nix.extraOptions = ''
        experimental-features = ${lib.concatStringsSep " " experimental-features }
        substituters = ${lib.concatStringsSep " " substituters }
        trusted-public-keys = ${lib.concatStringsSep " " trusted-public-keys }
      '';

    };

  globalDefaults = { self, hmUsers }:
    { config, pkgs, ... }: {
      users.mutableUsers = lib.mkDefault false;

      hardware.enableRedistributableFirmware = lib.mkDefault true;

      # digga lib can be accessed in modules directly as config.lib.digga
      lib = {
        inherit (pkgs.lib) digga;
      };

      _module.args = {
        inherit self hmUsers;
        hosts = builtins.mapAttrs (_: host: host.config)
          (removeAttrs self.nixosConfigurations [ config.networking.hostName ]);
      };

      system.configurationRevision = lib.mkIf (self ? rev) self.rev;
    };

  isoConfig = { self, fullHostConfig }:
    { config, modulesPath, suites, ... }@args: {

      imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix" ];
      # avoid unwanted systemd service startups
      disabledModules =
        if (suites != null)
        then
          let
            allProfiles = lib.foldl
              (lhs: rhs: lhs ++ rhs) [ ]
              (builtins.attrValues suites);
          in
          # we choose to satisfy the path contract of disabledModules
          assert
          lib.assertMsg
            (builtins.all (p: lib.types.path.check p) allProfiles)
            "all profiles used in suites must be paths";
          allProfiles
        else
          lib.warn ''
            Any profiles that you have defined outside 'importables.suites'
            will not be disabled on this ISO. That means services defined
            there will unnessecarily launch on this installation medium.
          '' [ ];

      nix.registry = lib.mapAttrs (n: v: { flake = v; }) self.inputs;

      isoImage.isoBaseName = "nixos-" + config.networking.hostName;
      isoImage.contents = [{
        source = self;
        target = "/devos/";
      }];
      isoImage.storeContents = [
        self.devShell.${config.nixpkgs.system}
        # include also closures that are "switched off" by the
        # above profile filter on the local config attribute
        fullHostConfig.system.build.toplevel
      ];
      # still pull in tools of deactivated profiles
      environment.systemPackages = fullHostConfig.environment.systemPackages;

      # confilcts with networking.wireless which might be slightly
      # more useful on a stick
      networking.networkmanager.enable = lib.mkForce false;
      # confilcts with networking.wireless
      networking.wireless.iwd.enable = lib.mkForce false;

      # Set up a link-local boostrap network
      # See also: https://github.com/NixOS/nixpkgs/issues/75515#issuecomment-571661659
      networking.usePredictableInterfaceNames = lib.mkForce true; # so prefix matching works
      networking.useNetworkd = lib.mkForce true;
      networking.useDHCP = lib.mkForce false;
      networking.dhcpcd.enable = lib.mkForce false;
      systemd.network = {
        # https://www.freedesktop.org/software/systemd/man/systemd.network.html
        networks."boostrap-link-local" = {
          matchConfig = {
            Name = "en* wl* ww*";
          };
          networkConfig = {
            Description = "Link-local host bootstrap network";
            MulticastDNS = true;
            LinkLocalAddressing = "ipv6";
            DHCP = "yes";
          };
          address = [
            # fall back well-known link-local for situations where MulticastDNS is not available
            "fe80::47" # 47: n=14 i=9 x=24; n+i+x
          ];
          extraConfig = ''
            # Unique, yet stable. Based off the MAC address.
            IPv6LinkLocalAddressGenerationMode = "eui64"
          '';
        };
      };
    };
}


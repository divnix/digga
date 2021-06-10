{ lib }:
{
  hmDefaults = { specialArgs, modules }:
    { options, ... }: {
      config = lib.optionalAttrs (options ? home-manager) {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = specialArgs;
          sharedModules = modules;
        };
      };
    };

  globalDefaults = { self }:
    let
      experimentalFeatures = [
        "flakes"
        "nix-command"
      ];
    in
    { channel, config, pkgs, ... }: {
      users.mutableUsers = lib.mkDefault false;

      hardware.enableRedistributableFirmware = lib.mkDefault true;

      nix.nixPath = [
        "nixpkgs=${channel.input}"
        "nixos-config=${self}/lib/compat/nixos"
      ] ++ lib.optionals (self.inputs ? home) [
        "home-manager=${self.inputs.home}"
      ];

      # package and option is from fup
      environment.systemPackages = [ pkgs.fup-repl ];
      nix.generateRegistryFromInputs = lib.mkDefault true;

      nix.extraOptions = ''
        experimental-features = ${lib.concatStringsSep " "
          experimentalFeatures
        }
      '';

      # digga lib can be accessed in modules directly as config.lib.digga
      lib = {
        inherit (pkgs.lib) digga;
      };

      _module.args = {
        inherit self;
        hosts = builtins.mapAttrs (_: host: host.config)
          (removeAttrs self.nixosConfigurations [ config.networking.hostName ]);
      };

      system.configurationRevision = lib.mkIf (self ? rev) self.rev;
    };

  isoConfig = { self, fullHostConfig }:
    { config, modulesPath, ... }@args: {

      imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix" ];
      # avoid unwanted systemd service startups
      # all strings in disabledModules get appended to modulesPath
      # so convert each to list which can be coerced to string
      disabledModules = map lib.singleton (args.suites.allProfiles or [ ]);

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


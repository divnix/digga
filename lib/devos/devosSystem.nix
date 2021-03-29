{ lib, nixos, self, inputs, ... }:

{ modules, ... } @ args:
lib.nixosSystem (args // {
  modules =
    let
      moduleList = builtins.attrValues modules;
      modpath = "nixos/modules";

      fullHostConfig = (lib.nixosSystem (args // { modules = moduleList; })).config;

      isoConfig = (lib.nixosSystem
        (args // {
          modules = moduleList ++ [

            "${nixos}/${modpath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"

            ({ config, suites, ... }: {

              # avoid unwanted systemd service startups
              # all strings in disabledModules get appended to modulesPath
              # so convert each to list which can be coerced to string
              disabledModules = map (x: [ x ])
                (lib.remove modules.core suites.allProfiles);

              nix.registry = lib.mapAttrs (n: v: { flake = v; }) inputs;

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
            })
          ];
        })).config;
      hmConfig = (lib.nixosSystem
        (args // {
          modules = moduleList ++ [
            ({ config, ... }: {
              home-manager.useUserPackages = lib.mkForce false;
              home-manager.sharedModules = [
                {
                  home.sessionVariables = {
                    inherit (config.environment.sessionVariables) NIX_PATH;
                  };
                  xdg.configFile."nix/registry.json".text =
                    config.environment.etc."nix/registry.json".text;
                }
              ];
            })
          ];
        })).config;
    in
    moduleList ++ [{
      system.build = {
        iso = isoConfig.system.build.isoImage;
        homes = hmConfig.home-manager.users;
      };
    }];
})

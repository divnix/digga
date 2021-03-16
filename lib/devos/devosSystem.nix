{ lib, nixos, self, ... }:

{ modules, ... } @ args:
lib.nixosSystem (args // {
  modules =
    let
      modpath = "nixos/modules";
      cd = "installer/cd-dvd/installation-cd-minimal-new-kernel.nix";

      isoConfig = (lib.nixosSystem
        (args // {
          modules = modules ++ [
            "${nixos}/${modpath}/${cd}"
            ({ config, ... }: {
              isoImage.isoBaseName = "nixos-" + config.networking.hostName;
              isoImage.contents = [{
                source = self;
                target = "/devos/";
              }];
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
    in
    modules ++ [{
      system.build = {
        iso = isoConfig.system.build.isoImage;
      };
    }];
})

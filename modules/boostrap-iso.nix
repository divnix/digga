let
  protoModule = fullHostConfig: { config, lib, modulesPath, suites, self, ... }@args: {

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
in
{ config, ... }:
{
  system.build = {
    boostrapIso = (config.lib.digga.mkBuild
      (protoModule config)
    ).config.system.build.isoImage;
  };
}


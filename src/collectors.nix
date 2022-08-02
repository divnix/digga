{ lib }:
let
  collectHosts = nixosConfigurations: darwinConfigurations:
    /**
      Synopsis: collectHosts _nixosConfigurations_ _darwinConfigurations_

      Collect all hosts across NixOS and Darwin configurations, validating for
      unique hostnames to prevent collisions.
      **/
    (nixosConfigurations // lib.mapAttrs
      (name: value:
        if builtins.hasAttr name nixosConfigurations
        then
          throw ''
            Hostnames must be unique across all platforms! Found a duplicate host config for '${name}'.
          ''
        else value
      )
      darwinConfigurations);
in
{
  inherit collectHosts;

  collectHostsOnSystem = hostConfigurations: system:
    /**
      Synopsis: collectHostsOnSystem _hostConfigurations_ _system_

      Filter a set of host configurations to those matching a given system.
      **/
    let
      systemSieve = _: host: host.config.nixpkgs.system == system;
    in
    lib.filterAttrs systemSieve hostConfigurations;
}

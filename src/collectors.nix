{ lib }:
let
  collectHosts = nixosHosts: darwinHosts:
    /**
      Synopsis: hostsOnSystem _hostOutputs_ _system_

      **/
    (nixosHosts // lib.mapAttrs (name: value:
        if builtins.hasAttr name nixosHosts
        then throw ''
          Hostnames must be unique across all platforms! Found a duplicate host config for '${name}'.
        ''
        else value
      )
      darwinHosts);
in
{
  inherit collectHosts;
}

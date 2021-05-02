{ lib }:

nixosConfigurations:

with lib;
let
  mkHomes = hostName: host:
    mapAttrs' (user: v: nameValuePair "${user}@${hostName}" v.home)
      # So this function is useful for non-devos hosts
      (host.config.system.build.homes or host.config.home-manager.users);

  hmConfigs = mapAttrs mkHomes nixosConfigurations;

in
foldl recursiveUpdate { } (attrValues hmConfigs)

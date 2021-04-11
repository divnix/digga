{ lib, self, ... }:

with lib;
let
  mkHomes = host: config:
    mapAttrs' (user: v: nameValuePair "${user}@${host}" v.home)
      config.config.system.build.homes;

  hmConfigs = mapAttrs mkHomes self.nixosConfigurations;

in
foldl recursiveUpdate { } (attrValues hmConfigs)

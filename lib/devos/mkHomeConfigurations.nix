{ lib, userSelf, ... }:

with lib;
let
  mkHomes = host: config:
    mapAttrs' (user: v: nameValuePair "${user}@${host}" v.home)
      config.config.system.build.homes;

  hmConfigs = mapAttrs mkHomes userSelf.nixosConfigurations;

in
foldl recursiveUpdate { } (attrValues hmConfigs)

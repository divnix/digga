{ lib }:
{
  mkHomeConfigurations = nixosConfigurations:
    with lib;
    let
      mkHomes = host: config:
        mapAttrs' (user: v: nameValuePair "${user}@${host}" v.home)
          config.config.system.build.homes;

      hmConfigs = mapAttrs mkHomes nixosConfigurations;

    in
    foldl recursiveUpdate { } (attrValues hmConfigs);

  mkDeployNodes =
    /**
      Synopsis: mkNodes _nixosConfigurations_

      Generate the `nodes` attribute expected by deploy-rs
      where _nixosConfigurations_ are `nodes`.
      **/

    deploy: lib.mapAttrs (_: config: {
      hostname = config.config.networking.hostName;

      profiles.system = {
        user = "root";
        path = deploy.lib.x86_64-linux.activate.nixos config;
      };
    });

  mkSuites = { suites, profiles }:
    let
      profileSet = lib.genAttrs' profiles (path: {
        name = baseNameOf path;
        value = lib.mkProfileAttrs (toString path);
      });

      definedSuites = suites profileSet;

      allProfiles = lib.collectProfiles profileSet;
    in
    lib.mapAttrs (_: v: lib.profileMap v) definedSuites // {
      inherit allProfiles;
    };
}

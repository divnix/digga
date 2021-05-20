{ lib, deploy }:
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

  mkDeployNodes = hosts: extraConfig:
    /**
      Synopsis: mkNodes _nixosConfigurations_

      Generate the `nodes` attribute expected by deploy-rs
      where _nixosConfigurations_ are `nodes`.
      **/

    lib.mapAttrs
      (_: config: lib.recursiveUpdate
        {
          hostname = config.config.networking.hostName;

          profiles.system = {
            user = "root";
            path = deploy.lib.${config.config.nixpkgs.system}.activate.nixos config;
          };
        }
        extraConfig)
      hosts;

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

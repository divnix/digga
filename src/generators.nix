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

  # DEPRECATED, suites no longer needs an explicit function after the importables generalization
  # deprecation message for suites is already in evalArgs
  mkSuites = { suites, profiles }:
    let
      profileSet = lib.genAttrs' profiles (path: {
        name = baseNameOf path;
        value = lib.mkProfileAttrs (toString path);
      });

      definedSuites = lib.mapAttrs (_: v: lib.profileMap v) (suites profileSet);

      allProfiles = lib.foldl (lhs: rhs: lhs ++ rhs) [ ] (builtins.attrValues definedSuites);
    in
    definedSuites // {
      inherit allProfiles;
    };
}

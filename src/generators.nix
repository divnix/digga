{ lib, deploy }:
{
  mkHomeConfigurations = nixosConfigurations:
    /**
      Synopsis: mkHomeConfigurations _nixosConfigurations_

      Generate the `homeConfigurations` attribute expected by
      `home-manager` cli from _nixosConfigurations_ in the form
      _user@hostname_.
      **/
    let
      op = attrs: c:
        attrs
        //
        (
          let
            net = c.config.networking;
            fqdn =
              if net.domain != null
              then "${net.hostName}.${net.domain}"
              else net.hostName;
          in
          lib.mapAttrs'
            (user: v: {
              name = "${user}@${fqdn}";
              value = v.home;
            })
            # build a modified variant of the home activation
            # scripts for self.homeConfigurations
            (c.config.lib.digga.mkBuild {
              # use $HOME/.nix-profile and hm's activation script
              # on hosts without system hm support
              home-manager.useUserPackages = lib.mkForce false;
            }).config.home-manager.users
        )
      ;
      mkHmConfigs = lib.foldl op { };
    in
    mkHmConfigs (builtins.attrValues nixosConfigurations);

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
    in
    lib.mapAttrs (_: v: lib.profileMap v) (suites profileSet);
}

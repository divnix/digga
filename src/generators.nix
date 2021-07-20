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
            c.config.home-manager.users
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
}

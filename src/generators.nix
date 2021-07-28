{ lib, deploy }:
let
  getFqdn = c:
    let
      net = c.config.networking;
      fqdn =
        if net.domain != null
        then "${net.hostName}.${net.domain}"
        else net.hostName;
    in
    fqdn;

in
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
          lib.mapAttrs'
            (user: v: {
              name = "${user}@${getFqdn c}";
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
      (_: c: lib.recursiveUpdate
        {
          hostname = getFqdn c;

          profiles.system = {
            user = "root";
            path = deploy.lib.${c.config.nixpkgs.system}.activate.nixos c;
          };
        }
        extraConfig)
      hosts;
}

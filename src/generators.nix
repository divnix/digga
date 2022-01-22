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
  mkHomeConfigurations = systemConfigurations:
    /**
      Synopsis: mkHomeConfigurations _systemConfigurations_

      Generate the `homeConfigurations` attribute expected by
      `home-manager` cli from _nixosConfigurations_ or _darwinConfigurations_
      in the form _user@hostname_.
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
    mkHmConfigs (builtins.attrValues systemConfigurations);

  mkDeployNodes = hosts: extraConfig:
    /**
      Synopsis: mkNodes _nixosConfigurations_

      Generate the `nodes` attribute expected by deploy-rs
      where _nixosConfigurations_ are `nodes`.

      Example input:
      ```
      {
      hostname-1 = {
      fastConnection = true;
      sshOpts = [ "-p" "25" ];
      };
      hostname-2 = {
      sshOpts = [ "-p" "19999" ];
      sshUser = "root";
      };
      }
      ```
      **/
    lib.recursiveUpdate
      (lib.mapAttrs
        (_: c:
          {
            hostname = getFqdn c;
            profiles.system = {
              user = "root";
              path = deploy.lib.${c.config.nixpkgs.system}.activate.nixos c;
            };
          }
        )
        hosts)
      extraConfig;
}

{ lib, deploy }:
let
  getFqdn = c:
    let
      net = c.config.networking;
      fqdn =
        if (net ? domain) && (net.domain != null)
        then "${net.hostName}.${net.domain}"
        else net.hostName;
    in
    fqdn;

in
{
  mkHomeConfigurations = systemConfigurations:
    /**
      Synopsis: mkHomeConfigurations _systemConfigurations_

      Generate the `homeConfigurations` attribute expected by `home-manager` cli
      from _nixosConfigurations_ or _darwinConfigurations_ in the form
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
    mkHmConfigs (builtins.attrValues systemConfigurations);

  mkDeployNodes = systemConfigurations: extraConfig:
    /**
      Synopsis: mkNodes _systemConfigurations_ _extraConfig_

      Generate the `nodes` attribute expected by deploy-rs
      where _systemConfigurations_ are `nodes`.

      _systemConfigurations_ should take the form of a flake's
      _nixosConfigurations_. Note that deploy-rs does not currently support
      deploying to darwin hosts.

      _extraConfig_, if specified, will be merged into each of the
      nodes' configurations.

      Example _systemConfigurations_ input:

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
        systemConfigurations)
      extraConfig;
}

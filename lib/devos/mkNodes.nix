{ lib, ... }:

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
})

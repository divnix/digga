{ lib, ... }:

{ self }:
let hmConfigs =
  lib.mapAttrs
    (_: config: config.config.home-manager.users)
    self.nixosConfigurations;
in
lib.mapAttrs
  (_: x: lib.mapAttrs
    (_: cfg: cfg.home.activationPackage)
    x)
  hmConfigs

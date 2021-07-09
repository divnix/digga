{ lib, pkgs, self, config, modules, channel, ... }:
{
  system.build = {
    iso = (config.lib.digga.mkBuild
      (config.lib.digga.modules.isoConfig {
        inherit self;
        fullHostConfig = config;
      })
    ).config.system.build.isoImage;
  };
}

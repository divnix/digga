{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.gamemode;
in
{
  options.services.gamemode = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the gamemoded systemd user service.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gamemode ];

    services.dbus.packages = [ pkgs.gamemode ];

    systemd.user.services.gamemoded = {
      description = "gamemoded";

      serviceConfig = {
        Type = "dbus";
        BusName = "com.feralinteractive.GameMode";
        NotifyAccess = "main";
        ExecStart = "${pkgs.gamemode}/bin/gamemoded";
      };

      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };
}

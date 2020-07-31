{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.wii-u-gc-adapter;
in
{
  options = {
    services.wii-u-gc-adapter = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable wii-u-gc-adapter service to automatically start
          when the controller adapter is plugged in.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    services.udev.extraRules = ''
      # start wii-u-gc-adapter when plugged in
      ACTION=="add", SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="057e", \
        ENV{ID_MODEL_ID}=="0337", TAG+="systemd", \
        ENV{SYSTEMD_ALIAS}="/sys/subsystem/usb/wii-u-gc-adapter", \
        ENV{SYSTEMD_WANTS}+="wii-u-gc-adapter.service"

      # workaround for https://github.com/systemd/systemd/issues/7587
      ACTION=="remove", SUBSYSTEM=="usb", ENV{PRODUCT}=="57e/337/100", \
        TAG+="systemd"
    '';

    systemd.services.wii-u-gc-adapter = {
      enable = true;
      script = ''
        ${pkgs.wii-u-gc-adapter}/bin/wii-u-gc-adapter
      '';
      unitConfig = { StopWhenUnneeded = true; };
    };
  };
}

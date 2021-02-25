{ config, lib, pkgs, ... }:
let inherit (builtins) readFile;
in
{
  sound.enable = true;

  environment = {
    etc."xdg/qutebrowser/config.py".text =
      let mpv = "${pkgs.mpv}/bin/mpv";
      in
      ''
        ${readFile ./config.py}
        ${lib.optionalString
          (config.networking.extraHosts != "")
          "c.content.blocking.enabled = False"
        }

        c.qt.args.append('widevine-path=${pkgs.widevine-cdm}/lib/libwidevinecdm.so')

        config.bind(',m', 'hint links spawn -d ${mpv} {hint-url}')
        config.bind(',v', 'spawn -d ${mpv} {url}')
      '';

    sessionVariables.BROWSER = "qute";

    systemPackages = with pkgs; [ qute qutebrowser mpv youtubeDL rofi ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      # wrapper to specify config file
      qute = prev.writeShellScriptBin "qute" ''
        QUTE_DARKMODE_VARIANT=qt_515_2 QT_QPA_PLATFORMTHEME= exec ${final.qutebrowser}/bin/qutebrowser -C /etc/xdg/qutebrowser/config.py "$@"
      '';
    })
  ];
}

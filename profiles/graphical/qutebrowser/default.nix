{ pkgs, ... }:
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

        config.bind(',m', 'hint links spawn -d ${mpv} {hint-url}')
        config.bind(',v', 'spawn -d ${mpv} {url}')
      '';

    sessionVariables.BROWSER = "qute";

    systemPackages = with pkgs; [ qute qutebrowser mpv youtubeDL ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      # wrapper to specify config file
      qute = prev.writeShellScriptBin "qute" ''
        QT_QPA_PLATFORMTHEME= exec ${prev.qutebrowser}/bin/qutebrowser -C /etc/xdg/qutebrowser/config.py "$@"
      '';
    })
  ];
}

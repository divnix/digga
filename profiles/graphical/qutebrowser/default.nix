{ pkgs, ... }:
let inherit (builtins) readFile;
in {
  sound.enable = true;

  environment = {
    etc."xdg/qutebrowser/config.py".text = let mpv = "${pkgs.mpv}/bin/mpv";
    in ''
      ${readFile ./config.py}

      config.bind(',m', 'hint links spawn -d ${mpv} {hint-url}')
      config.bind(',v', 'spawn -d ${mpv} {url}')
    '';

    sessionVariables.BROWSER = "qute";

    systemPackages = with pkgs; [ qute qutebrowser mpv youtubeDL ];
  };
}

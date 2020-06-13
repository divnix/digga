{ unstablePkgs, ... }:
let inherit (builtins) readFile;
in {
  sound.enable = true;

  environment = {
    etc."xdg/qutebrowser/config.py".text =
      let mpv = "${unstablePkgs.mpv}/bin/mpv";
      in ''
        ${readFile ./config.py}

        config.bind(',m', 'hint links spawn -d ${mpv} {hint-url}')
        config.bind(',v', 'spawn -d ${mpv} {url}')
      '';

    sessionVariables.BROWSER = "qute";

    systemPackages = with unstablePkgs; [ qute qutebrowser mpv youtubeDL ];
  };
}

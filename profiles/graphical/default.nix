{ config, pkgs, ... }:
let
  inherit (builtins)
    readFile
    ;
in
{
  imports = [
    ./sway
    ../develop
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  sound.enable = true;

  environment = {
    etc = {
      "xdg/gtk-3.0/settings.ini" = {
        text = ''
            [ Settings ]
            gtk-icon-theme-name=Papirus-Adapta
          gtk-theme-name=Adapta
          gtk-cursor-theme-name=Adwaita
        '';
        mode = "444";
      };

      "xdg/qutebrowser/config.py".text = let
        mpv = "${pkgs.mpv}/bin/mpv";
      in
        ''
          ${readFile ./qutebrowser/config.py}

          config.bind(',m', 'hint links spawn -d ${mpv} {hint-url}')
          config.bind(',v', 'spawn -d ${mpv} {url}')
        '';
    };

    sessionVariables = {
      # default browser
      BROWSER = "qute";

      # Theme settings
      QT_QPA_PLATFORMTHEME = "gtk2";
      GTK2_RC_FILES = let
        gtk = ''
          gtk-icon-theme-name="Papirus-Adapta"
          gtk-cursor-theme-name="Adwaita"
        '';
      in
        [
          (''${ pkgs.writeText "iconrc" "${gtk}" }'')
          "${pkgs.adapta-gtk-theme}/share/themes/Adapta/gtk-2.0/gtkrc"
          "${pkgs.gnome3.gnome-themes-extra}/share/themes/Adwaita/gtk-2.0/gtkrc"
        ];
    };

    systemPackages = with pkgs; [
      adapta-gtk-theme
      cursor
      dzen2
      feh
      ffmpeg_4
      firefox
      gnome3.adwaita-icon-theme
      gnome-themes-extra
      imagemagick
      imlib2
      librsvg
      libsForQt5.qtstyleplugins
      mpv
      networkmanager_dmenu
      papirus-icon-theme
      qute
      qutebrowser
      sddm-chili
      youtubeDL
      zathura
    ];
  };

  services.xserver = {
    enable = true;

    desktopManager.plasma5.enable = true;

    displayManager.sddm = {
      enable = true;
      theme = "chili";
    };
  };

  nixpkgs.overlays = let
    overlay = self: super: {
      qute = super.writeShellScriptBin "qute" ''
        exec ${super.qutebrowser}/bin/qutebrowser -C /etc/xdg/qutebrowser/config.py "$@"
      '';

      cursor = super.writeTextDir "share/icons/default/index.theme" ''
        [icon theme]
        Inherits=Adwaita
      '';

      sddm-chili = super.callPackage ../../pkgs/applications/display-managers/sddm/themes/chili {};
    };
  in
    [ overlay ];
}

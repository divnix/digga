{ config, pkgs, ... }:
let
  inherit (builtins)
    readFile
    ;
in
{
  imports = [
    ./sway
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
      GDK_PIXBUF_MODULE_FILE =
        "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
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
      youtubeDL
      zathura
    ];
  };

  nixpkgs.overlays = let
    qutebrowser = self: super: {
      qute = super.writeShellScriptBin "qute" ''
        ${super.qutebrowser}/bin/qutebrowser -C /etc/xdg/qutebrowser/config.py "$@"
      '';

      cursor = super.writeTextDir "share/icons/default/index.theme" ''
        [icon theme]
        Inherits=Adwaita
      '';
    };
  in
    [ qutebrowser ];
}

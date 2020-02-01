final: prev: {
  # wrapper to specify config file
  qute = prev.writeShellScriptBin "qute" ''
    QT_QPA_PLATFORMTHEME= exec ${prev.qutebrowser}/bin/qutebrowser -C /etc/xdg/qutebrowser/config.py "$@"
  '';
}

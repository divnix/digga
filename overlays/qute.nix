final: prev: {
  # wrapper to specify config file
  qute = prev.writeShellScriptBin "qute" ''
    exec ${prev.qutebrowser}/bin/qutebrowser -C /etc/xdg/qutebrowser/config.py "$@"
  '';
}

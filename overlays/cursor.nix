final: prev: {
  # set default cursor theme when installed
  cursor = prev.writeTextDir "share/icons/default/index.theme" ''
    [icon theme]
    Inherits=Adwaita
  '';
}

final: prev: {
  sddm-chili =
    prev.callPackage ./applications/display-managers/sddm/themes/chili { };
  dejavu_nerdfont = prev.callPackage ./data/fonts/dejavu-nerdfont { };
  purs = prev.callPackage ./shells/zsh/purs { };
  pure = prev.callPackage ./shells/zsh/pure { };
  dzvol = prev.callPackage ./applications/misc/dzvol.nix { };
}

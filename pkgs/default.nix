self: super: {
  sddm-chili = super.callPackage ./applications/display-managers/sddm/themes/chili {};
  dejavu_nerdfont = super.callPackage ./data/fonts/dejavu-nerdfont {};
  purs = super.callPackage ./shells/zsh/purs {};
}

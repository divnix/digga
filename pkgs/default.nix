final: prev: {
  sddm-chili =
    prev.callPackage ./applications/display-managers/sddm/themes/chili { };
  dejavu_nerdfont = prev.callPackage ./data/fonts/dejavu-nerdfont { };
  purs = prev.callPackage ./shells/zsh/purs { };
  lib = prev.lib // { utils = import ../lib/utils.nix { lib = prev.lib; }; };
}

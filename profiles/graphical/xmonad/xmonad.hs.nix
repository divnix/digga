{ pkgs, ... }:
let
  inherit (builtins) readFile;
  inherit (pkgs) writeScript;

  screenshots = "Pictures/shots";

  autostart = writeScript "xmonad-autostart" (readFile ./scripts/autostart);

  stoggle = writeScript "xmonad-stoggle" (readFile ./scripts/stoggle);

  touchtoggle =
    writeScript "xmonad-touchtoggle" (readFile ./scripts/touchtoggle);

  volnoti = import ../misc/volnoti.nix { inherit pkgs; };
in ''
  ${readFile ./_xmonad.hs}
  ${import ./_xmonad.nix {
    inherit screenshots touchtoggle autostart stoggle pkgs volnoti;
  }}
''

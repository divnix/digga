{ lib, profiles }:
let
  inherit (builtins) mapAttrs isFunction;
  all =
    let
      filtered = lib.filterAttrs (n: _: n != "core") profiles;
    in
    lib.collect isFunction filtered;
in
with profiles;
mapAttrs (_: v: lib.flk.profileMap v)
  rec {
    work = [ develop virt ];

    graphics = work ++ [ graphical ];

    mobile = graphics ++ [ laptop ];

    play = graphics ++ [
      graphical.games
      torrent
      misc.disable-mitigations
    ];

    goPlay = play ++ [ laptop ];
  } // {
  inherit all;
}

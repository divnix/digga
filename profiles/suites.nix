{ lib, profiles }:
let
  inherit (builtins) mapAttrs isFunction;

  allProfiles =
    let
      filtered = lib.filterAttrs (n: _: n != "core") profiles;
    in
    lib.collect isFunction filtered;

  allUsers = lib.collect isFunction users;

  users = lib.flk.defaultImports (toString ../users);
in
with profiles;
mapAttrs (_: v: lib.flk.profileMap v)
  # define your own suites below
  rec {
    work = [ develop virt users.nixos users.root ];

    graphics = work ++ [ graphical ];

    mobile = graphics ++ [ laptop ];

    play = graphics ++ [
      graphical.games
      torrent
      misc.disable-mitigations
    ];

    goPlay = play ++ [ laptop ];
  } // {
  inherit allProfiles allUsers;
}

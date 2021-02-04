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
    core = [ users.nixos users.root ];
  } // {
  inherit allProfiles allUsers;
}

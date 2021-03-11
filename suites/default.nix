{ lib }:
let
  inherit (lib) dev;

  profiles = dev.mkProfileAttrs (toString ../profiles);
  users = dev.mkProfileAttrs (toString ../users);

  allProfiles =
    let defaults = lib.collect (x: x ? default) profiles;
    in map (x: x.default) defaults;

  allUsers =
    let defaults = lib.collect (x: x ? default) users;
    in map (x: x.default) defaults;


  suites = with profiles; rec {
    base = [ users.nixos users.root ];
  };
in
lib.mapAttrs (_: v: dev.profileMap v) suites // {
  inherit allProfiles allUsers;
}

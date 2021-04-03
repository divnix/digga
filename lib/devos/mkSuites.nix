{ lib, ... }:

{ users, profiles, userProfiles, suites } @ args:
let

  definedSuites = suites {
    inherit (args) users profiles userProfiles;
  };

  allProfiles =
    let defaults = lib.collect (x: x ? default) profiles;
    in map (x: x.default) defaults;

  allUsers =
    let defaults = lib.collect (x: x ? default) users;
    in map (x: x.default) defaults;

  createSuites = _: suites: lib.mapAttrs (_: v: lib.os.profileMap v) suites // {
    inherit allProfiles allUsers;
  };

in
lib.mapAttrs createSuites definedSuites

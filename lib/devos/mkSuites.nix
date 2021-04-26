{ lib }:

{ users, profiles, userProfiles, suites } @ args:
let
  inherit (lib) os;

  definedSuites = suites {
    inherit (args) users profiles userProfiles;
  };

  allProfiles = lib.collectProfiles profiles;

  allUsers = lib.collectProfiles users;

  createSuites = _: suites: lib.mapAttrs (_: v: os.profileMap v) suites // {
    inherit allProfiles allUsers;
  };

in
lib.mapAttrs createSuites definedSuites

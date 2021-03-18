{ lib }:
let
  inherit (lib) dev;

  profiles = dev.os.mkProfileAttrs (toString ../profiles);
  users = dev.os.mkProfileAttrs (toString ../users);

  allProfiles = lib.attrValues profiles;

  allUsers = lib.attrValues users;


  suites = with profiles; rec {
    base = [ users.nixos users.root ];
  };
in
lib.mapAttrs (_: v: dev.os.profileMap v) (suites // {
  inherit allProfiles allUsers;
})

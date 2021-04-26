{ lib }:

{ suites, profiles } @ args:
let
  inherit (lib) os;

  profileSet = lib.genAttrs' profiles (path: {
     name = baseNameOf path;
     value = os.mkProfileAttrs (toString path);
  });

  definedSuites = suites profileSet;

  allProfiles = lib.collectProfiles profileSet;
in
lib.mapAttrs (_: v: os.profileMap v) definedSuites // {
    inherit allProfiles;
}



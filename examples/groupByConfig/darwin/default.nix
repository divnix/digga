{ self, inputs, ... }:

let
  inherit (inputs.digga.lib) allProfilesTest;
in

{
  hostDefaults = {
    channelName = "nixpkgs-darwin-stable";
  };

  hosts = {
    Darwinia = {
      modules = [ ./Darwinia.nix ];
      # TODO: should we expect all of these tests to work on darwin? any
      # platform limitations?
      # tests = [ allProfilesTest ];
      tests = [];
    };
  };

  importables = rec {
    suites = rec {
      base = [ ];
    };
  };
}

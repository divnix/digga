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

      # TODO: add custom test support for darwin hosts
      # tests = [ allProfilesTest ];
      tests = [ ];
    };
  };

  importables = rec {
    suites = rec {
      base = [ ];
    };
  };
}

{
  self,
  inputs,
  ...
}: let
  inherit (inputs.digga.lib) allProfilesTest;
in {
  hostDefaults = {
    channelName = "nixos";
  };

  hosts = {
    Morty = {
      modules = [./Morty.nix];
      # FIXME: Causes infinite recursion
      # tests = [allProfilesTest];
    };
  };

  importables = rec {
    suites = rec {
      base = [];
    };
  };
}

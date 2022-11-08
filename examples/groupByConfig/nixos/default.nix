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
      tests = [allProfilesTest];
    };
  };

  importables = rec {
    suites = rec {
      base = [];
    };
  };
}

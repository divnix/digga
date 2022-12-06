{
  self,
  inputs,
  ...
}: let
  lib = inputs.digga.lib;
in {
  imports = [(lib.importExportableModules ./modules)];
  modules = [];
  importables = rec {
    profiles = lib.rakeLeaves ./profiles;
    suites = with profiles; {
      shell = with shell; [direnv];
    };
  };
  users = lib.rakeLeaves ./users;
  home.stateVersion = "22.05";
}

{ self, inputs, ... }:
let
  inherit (inputs.digga) lib;
in
{
  imports = [ (lib.importExportableModules ./modules) ];
  modules = [ ];
  importables = rec {
    profiles = lib.rakeLeaves ./profiles;
    suites = with profiles; {
      shell = with shell; [ direnv ];
    };
  };
  users = lib.rakeLeaves ./users;
}

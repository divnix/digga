{ self, inputs, ... }:
let
  imp = inputs.digga.lib.importers;
in
{
  imports = [ (imp.modules ./modules) ];
  externalModules = [ ];
  importables = rec {
    profiles = imp.rakeLeaves ./profiles;
    suites = with profiles; {
      shell = with shell; [ direnv ];
    };
  };
  users = imp.rakeLeaves ./users;
}

{ self, ... }: let
  imp = self.inputs.digga.lib.importers;
in {
  imports = [ (imp.modules ./modules) ];
}

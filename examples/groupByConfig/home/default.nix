{self, ...}: let
  lib = self.inputs.digga.lib;
<<<<<<< HEAD
in {
  imports = [(lib.importExportableModules ./modules)];
=======
in
{
  imports = [ (lib.importExportableModules ./modules) ];
  home.stateVersion = "22.05";
>>>>>>> cdbb1852b1b22cad4038adc0a7f7ac468b341a94
}

{ self, ... }:
let
  lib = self.inputs.digga.lib;
in
{
  imports = [ (lib.importExportableModules ./modules) ];
  home.stateVersion = "22.05";
}

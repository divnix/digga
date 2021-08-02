final: prev:
let
  sources = (import ./_sources/generated.nix) { inherit (self) fetchurl fetchgit; };

  mkVimPlugin = plugin:
    self.vimUtils.buildVimPluginFrom2Nix {
      inherit (plugin) pname version src;
    };

  newPkgsSet = pkgSet:
    let
      prefix = "${pkgSet}-";

      pkgSetBuilder = {
        "vimPlugins" = mkVimPlugin;
      }.${pkgSet};


      pkgsInSources = self.lib.mapAttrs' (name: value: self.lib.nameValuePair (self.lib.removePrefix prefix name) (value)) (self.lib.filterAttrs (n: v: self.lib.hasPrefix prefix n) sources);
    in
    self.lib.mapAttrs (n: v: pkgSetBuilder v) pkgsInSources;

in
{
  inherit sources;

  vimPlugins = super.vimPlugins // (newPkgsSet "vimPlugins");

}

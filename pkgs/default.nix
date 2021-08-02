final: prev:
let
  sources = (import ./_sources/generated.nix) { inherit (final) fetchurl fetchgit; };

  mkVimPlugin = plugin:
    final.vimUtils.buildVimPluginFrom2Nix {
      inherit (plugin) pname version src;
    };

  newPkgsSet = pkgSet:
    let
      prefix = "${pkgSet}-";

      pkgSetBuilder = {
        "vimPlugins" = mkVimPlugin;
      }.${pkgSet};


      pkgsInSources = final.lib.mapAttrs' (name: value: final.lib.nameValuePair (final.lib.removePrefix prefix name) (value)) (final.lib.filterAttrs (n: v: final.lib.hasPrefix prefix n) sources);
    in
    final.lib.mapAttrs (n: v: pkgSetBuilder v) pkgsInSources;

in
{
  inherit sources;

  vimPlugins = prev.vimPlugins // (newPkgsSet "vimPlugins");

}

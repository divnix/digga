{ lib }:
let
  recImport = { dir, _import ? base: import "${dir}/${base}.nix" }:
    lib.mapFilterAttrs
      (_: v: v != null)
      (n: v:
        if n != "default.nix" && lib.hasSuffix ".nix" n && v == "regular"
        then
          let name = lib.removeSuffix ".nix" n; in lib.nameValuePair (name) (_import name)
        else
          lib.nameValuePair ("") (null))
      (lib.safeReadDir dir);

  mkProfileAttrs =
    /**
      Synopsis: mkProfileAttrs _path_

      Recursively collect the subdirs of _path_ containing a default.nix into attrs.
      This sets a contract, eliminating ambiguity for _default.nix_ living under the
      profile directory.

      Example:
      let profiles = mkProfileAttrs ./profiles; in
      assert profiles ? core.default; 0
      **/
    dir:
    let
      imports =
        let
          files = lib.safeReadDir dir;

          p = n: v:
            v == "directory"
            && n != "profiles";
        in
        lib.filterAttrs p files;

      f = n: _:
        lib.optionalAttrs
          (lib.pathExists "${dir}/${n}/default.nix")
          { default = "${dir}/${n}"; }
        // mkProfileAttrs "${dir}/${n}";
    in
    lib.mapAttrs f imports;

in
{
  inherit recImport mkProfileAttrs;

  pathsIn = dir:
    let
      fullPath = name: "${toString dir}/${name}";
    in
    map fullPath (lib.attrNames (lib.safeReadDir dir));

  importHosts = dir:
    recImport {
      inherit dir;
      _import = base: {
        modules = import "${toString dir}/${base}.nix";
      };
    };
}


{ lib, dev, ... }:

{ dir, _import ? base: import "${dir}/${base}.nix" }:
dev.mapFilterAttrs
  (_: v: v != null)
  (n: v:
    if n != "default.nix" && lib.hasSuffix ".nix" n && v == "regular"
    then
      let name = lib.removeSuffix ".nix" n; in lib.nameValuePair (name) (_import name)
    else
      lib.nameValuePair ("") (null))
  (dev.safeReadDir dir)

{ lib, dev, ... }:
{
  pathsIn = dir:
    let
      fullPath = name: "${dir}/${name}";
    in
    map fullPath (lib.attrNames (dev.safeReadDir dir));
}

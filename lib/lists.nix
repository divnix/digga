{ lib, ... }:
{
  pathsIn = dir:
    let
      fullPath = name: "${toString dir}/${name}";
    in
    map fullPath (lib.attrNames (lib.optionalAttrs
      (builtins.pathExists dir) (builtins.readDir dir)));
}

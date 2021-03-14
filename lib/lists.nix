{ lib, ... }:
{
  pathsIn = dir:
    let
      fullPath = name: "${toString dir}/${name}";
    in
    map fullPath (lib.attrNames (builtins.readDir dir));
}

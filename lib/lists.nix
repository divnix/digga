{ lib }:
{
  pathsIn = dir:
    let
      fullPath = name: "${toString dir}/${name}";
    in
    map fullPath (lib.attrNames (lib.safeReadDir dir));

  unifyOverlays = channels: map (o: if isFunction (o null null) then o channels else o);
}

{ lib }:
{
  collectProfiles = set:
    let
      collectNestedProfiles = set:
        lib.mapAttrsToList (n: v:
          if builtins.isAttrs v then
            [ v.default or null ] ++ collectNestedProfiles v
          else null
        ) set;
    in
      builtins.filter (x: x != null) (lib.flatten (collectNestedProfiles set));

  pathsIn = dir:
    let
      fullPath = name: "${toString dir}/${name}";
    in
    map fullPath (lib.attrNames (lib.safeReadDir dir));
}

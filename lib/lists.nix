{ lib }:
{
  collectProfiles = set:
    let
      collectNestedProfiles = set:
        lib.mapAttrsToList
          (n: v:
            if builtins.isAttrs v then
              [ v.default or null ] ++ collectNestedProfiles v
            else null
          )
          set;
    in
    builtins.filter (x: x != null) (lib.flatten (collectNestedProfiles set));

  profileMap = list: map (profile: profile.default) (lib.flatten list);

  unifyOverlays = channels: map (o: if builtins.isFunction (o null null) then o channels else o);
}

{ lib }:
{
  unifyOverlays = channels: map (o: if builtins.isFunction (o null null) then o channels else o);
}

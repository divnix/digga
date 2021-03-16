{ lib, dev, self, ... }:

{ pkgs }:
let
  inherit (self) overlay overlays;
  packagesNames = lib.attrNames (overlay null null)
    ++ lib.attrNames (dev.concatAttrs
    (lib.attrValues
      (lib.mapAttrs (_: v: v null null) overlays)
    )
  );
in
lib.fold
  (key: sum: lib.recursiveUpdate sum {
    ${key} = pkgs.${key};
  })
{ }
  packagesNames

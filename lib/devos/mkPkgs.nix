{ lib, utils }:

{ userFlakeNixOS, userFlakeSelf, userFlakeInputs }:

{ extern, overrides }:
(utils.lib.eachDefaultSystem
  (system:
    let
      overridePkgs = lib.os.pkgImport userFlakeInputs.override [ ] system;
      overridesOverlay = overrides.packages;

      overlays = [
        (final: prev: {
          lib = prev.lib.extend (lfinal: lprev: {
            inherit lib;
            inherit (lib) nixosSystem;
          });
        })
        (overridesOverlay overridePkgs)
        userFlakeSelf.overlay
      ]
      ++ extern.overlays
      ++ (lib.attrValues userFlakeSelf.overlays);
    in
    { pkgs = lib.os.pkgImport userFlakeNixOS overlays system; }
  )
).pkgs

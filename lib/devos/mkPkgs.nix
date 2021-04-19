{ lib, nixpkgs, userFlakeSelf, utils, userFlakeInputs, ... }:

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

            utils = inputs.utils.lib;
          });
        })
        (overridesOverlay overridePkgs)
        userFlakeSelf.overlay
      ]
      ++ extern.overlays
      ++ (lib.attrValues userFlakeSelf.overlays);
    in
    { pkgs = lib.os.pkgImport nixpkgs overlays system; }
  )
).pkgs

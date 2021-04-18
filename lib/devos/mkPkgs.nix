{ lib, nixpkgs, userSelf, inputs, ... }:

{ extern, overrides }:
(inputs.utils.lib.eachDefaultSystem
  (system:
    let
      overridePkgs = lib.os.pkgImport inputs.override [ ] system;
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
        userSelf.overlay
      ]
      ++ extern.overlays
      ++ (lib.attrValues userSelf.overlays);
    in
    { pkgs = lib.os.pkgImport nixpkgs overlays system; }
  )
).pkgs

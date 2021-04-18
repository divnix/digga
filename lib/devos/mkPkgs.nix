{ lib, dev, nixpkgs, userSelf, inputs, ... }:

{ extern, overrides }:
(inputs.utils.lib.eachDefaultSystem
  (system:
    let
      overridePkgs = dev.os.pkgImport inputs.override [ ] system;
      overridesOverlay = overrides.packages;

      overlays = [
        (final: prev: {
          lib = prev.lib.extend (lfinal: lprev: {
            inherit dev;
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
    { pkgs = dev.os.pkgImport nixpkgs overlays system; }
  )
).pkgs

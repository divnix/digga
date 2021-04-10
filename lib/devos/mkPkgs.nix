{ lib, dev, nixos, inputs, ... }:

# main overlay and extra overlays
{ overlay, overlays, extern, overrides }:
(inputs.utils.lib.eachDefaultSystem
  (system:
    let
      overridePkgs = dev.os.pkgImport inputs.override [ ] system;
      overridesOverlay = overrides.packages;

      allOverlays = [
        (final: prev: {
          lib = prev.lib.extend (lfinal: lprev: {
            inherit dev;
            inherit (lib) nixosSystem;

            utils = inputs.utils.lib;
          });
        })
        (overridesOverlay overridePkgs)
        overlay
      ]
      ++ extern.overlays
      ++ (lib.attrValues overlays);
    in
    { pkgs = dev.os.pkgImport nixos allOverlays system; }
  )
).pkgs

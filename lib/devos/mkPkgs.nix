{ lib, nixos, self, inputs, ... }:

{ extern, overrides }:
(inputs.utils.lib.eachDefaultSystem
  (system:
    let
      overridePkgs = lib.os.pkgImport inputs.override [ ] system;
      overridesOverlay = overrides.packages;

      overlays = [
        (overridesOverlay overridePkgs)
        self.overlay
      ]
      ++ extern.overlays
      ++ (lib.attrValues self.overlays);
    in
    { pkgs = lib.os.pkgImport nixos overlays system; }
  )
).pkgs

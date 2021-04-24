{ lib, utils }:

{ self, nixos, inputs, extern, overrides }:
(utils.lib.eachDefaultSystem
  (system:
    let
      overridePkgs = lib.os.pkgImport inputs.override [ ] system;
      overridesOverlay = overrides.packages;

      overlays = [
        (final: prev: {
          lib = prev.lib.extend (lfinal: lprev: {
            inherit lib;
            inherit (lib) nixosSystem;
          });
        })
        (overridesOverlay overridePkgs)
        self.overlay
      ]
      ++ extern.overlays
      ++ (lib.attrValues self.overlays);
    in
    { pkgs = lib.os.pkgImport nixos overlays system; }
  )
).pkgs

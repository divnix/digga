{ lib, dev, nixos, ... }:

{ self }:
let inherit (self) inputs;
in
(inputs.utils.lib.eachDefaultSystem
  (system:
    let
      extern = import ../../extern { inherit inputs; };
      overridePkgs = dev.os.pkgImport inputs.override [ ] system;
      overridesOverlay = (import ../../overrides).packages;

      overlays = [
        (overridesOverlay overridePkgs)
        self.overlay
        (final: prev: {
          lib = prev.lib.extend (lfinal: lprev: {
            inherit dev;
            inherit (lib) nixosSystem;

            utils = inputs.utils.lib;
          });
        })
      ]
      ++ extern.overlays
      ++ (lib.attrValues self.overlays);
    in
    { pkgs = dev.os.pkgImport nixos overlays system; }
  )
).pkgs

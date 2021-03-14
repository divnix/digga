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
          srcs =
            let
              mkVersion = name: input:
                let
                  inputs = (builtins.fromJSON
                    (builtins.readFile ../../flake.lock)).nodes;

                  ref =
                    if lib.hasAttrByPath [ name "original" "ref" ] inputs
                    then inputs.${name}.original.ref
                    else "";

                  version =
                    let version' = builtins.match
                      "[[:alpha:]]*[-._]?([0-9]+(\.[0-9]+)*)+"
                      ref;
                    in
                    if lib.isList version'
                    then lib.head version'
                    else if input ? lastModifiedDate && input ? shortRev
                    then "${lib.substring 0 8 input.lastModifiedDate}_${input.shortRev}"
                    else null;
                in
                version;
            in
            lib.mapAttrs
              (name: input:
                let
                  version = mkVersion name input;
                in
                input // lib.optionalAttrs (! isNull version)
                  {
                    inherit version;
                  }
              )
              self.inputs.srcs.inputs;
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

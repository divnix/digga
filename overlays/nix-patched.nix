{ inputs }:
final: prev: {

  __dontExport = true;

  # Use pinned version to guarantee reproducability
  # with this fast moving target. Flipside: not store
  # efficient.
  nixStable = inputs.latest.legacyPackages.${prev.system}.nixStable;

  nixos-rebuild = prev.nixos-rebuild.override {
    nix = final.nixStable;
  };

  # check if we need to override more stuff ourthe patched nix

}

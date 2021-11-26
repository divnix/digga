{ inputs }:
final: prev: {

  __dontExport = true;

  # Example:
  #
  # Use pinned version to guarantee reproducability
  # with this fast moving target. Flipside: not store
  # efficient.
  #nixUnstable = inputs.nix.packages.${prev.system}.nix;

  #nixos-rebuild = prev.nixos-rebuild.override {
  #  nix = final.nixUnstable;
  #};

  # check if we need to override more stuff ourthe patched nix

}

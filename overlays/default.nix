{ inputs }: {
  patchedNix = import ./nix-patched.nix { inherit inputs; };
}

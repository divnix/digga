final: prev: {
  nixFlakes = prev.nixFlakes.overrideAttrs
    (self: {
      patches = [
        ../pkgs/tools/package-management/nix/0001-nix-command-and-flakes-by-default.patch
      ];
    });
}

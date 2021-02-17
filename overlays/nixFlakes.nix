final: prev: {
  nixFlakes = prev.nixFlakes.overrideAttrs
    (self:
      let
        oldPatches = self.patches or [ ];
      in
      {
        patches = oldPatches ++ [
          ../pkgs/tools/package-management/nix/0001-nix-command-and-flakes-by-default.patch
        ];
      });
}

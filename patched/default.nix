final: prev: {

  __dontExport = true;

  nixUnstable = prev.nixUnstable.overrideAttrs (o: { patches = (o.patches or [ ]) ++ [

      # fixes nested `inputs.<name>.follows` syntax
      (prev.fetchpatch {
        name = "fix-follows.diff";
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/4641.patch";
        sha256 = "sha256-nyLMSltS9XjNaF446M5yV/o08XtZkYbU7yMVnqYERts=";
      })

    ];
  });

  nixos-rebuild = prev.nixos-rebuild.override {
    nix = final.nixUnstable;
  };

  # check if we need to override more stuff ourthe patched nix

}

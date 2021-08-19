{ inputs }:
final: prev: {

  __dontExport = true;

  nixUnstable = prev.nixUnstable.overrideAttrs (o: {
    src = inputs.nix;
    patches = (o.patches or [ ]) ++ [

      # fixes nested `inputs.<name>.follows` syntax
      (prev.fetchpatch {
        name = "fix-follows.diff";
        url = "https://patch-diff.githubusercontent.com/raw/NixOS/nix/pull/4641.patch";
        sha256 = "sha256-0xNgbyWFmD3UIHPNFrgKiSejGJfuVj1OjqbS1ReLJRc=";
      })

    ];
  });

  nixos-rebuild = prev.nixos-rebuild.override {
    nix = final.nixUnstable;
  };

  # check if we need to override more stuff ourthe patched nix

}

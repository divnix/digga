{ lib, ... }:
let
  inherit (builtins)
    attrNames
    isAttrs
    readDir
    ;


  inherit (lib)
    filterAttrs
    hasSuffix
    mapAttrs'
    nameValuePair
    removeSuffix
    ;

in
rec {
  # mapFilterAttrs ::
  #   (name -> value -> bool )
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = seive: f: attrs:
    filterAttrs seive (mapAttrs' f attrs);

  recImport =
    { dir
    , _import ? base: import "${dir}/${base}.nix"
    }:
      mapFilterAttrs
        (_: v: v != null)
        (
          n: v:
            if
              n != "default.nix"
              && hasSuffix ".nix" n
              && v == "regular"

            then let
              name = removeSuffix ".nix" n;
            in
              nameValuePair (name) (_import name)

            else
              nameValuePair ("") (null)
        )
        (readDir dir);
}

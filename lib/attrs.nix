{ lib }:
rec {
  # mapFilterAttrs ::
  #   (name -> value -> bool )
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = seive: f: attrs:
    lib.filterAttrs
      seive
      (lib.mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: lib.listToAttrs (map f values);

  concatAttrs = lib.fold (attr: sum: lib.recursiveUpdate sum attr) { };

  safeReadDir = path:
    lib.optionalAttrs (builtins.pathExists (toString path)) (builtins.readDir (toString path));
}

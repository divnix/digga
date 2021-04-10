{ lib, ... }:
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

  # Convert a list of file paths to attribute set where
  # the key is the folder or filename stripped of nix
  # extension and imported content of the file as value.
  #
  pathsToImportedAttrs = paths:
    let
      paths' = lib.filter
        (path: lib.hasSuffix ".nix" path
          || lib.pathExists "${path}/default.nix")
        paths;
    in
    genAttrs' paths' (path: {
      name = lib.removeSuffix ".nix"
        # Safe as long this is just used as a name
        (builtins.unsafeDiscardStringContext (baseNameOf path));
      value = import path;
    });

  concatAttrs = lib.fold (attr: sum: lib.recursiveUpdate sum attr) { };

  # Filter out packages that support given system and follow flake check requirements
  filterPackages = system: packages:
    let
      # Everything that nix flake check requires for the packages output
      filter = (n: v: with v; let platforms = meta.hydraPlatforms or meta.platforms or [ ]; in
      lib.isDerivation v && !meta.broken && builtins.elem system platforms);
    in
    lib.filterAttrs filter packages;

  safeReadDir = path: lib.optionalAttrs (builtins.pathExists path) (builtins.readDir path);
}

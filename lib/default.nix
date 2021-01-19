{ lib, ... }:
let
  inherit (builtins) attrNames attrValues isAttrs readDir listToAttrs mapAttrs;

  inherit (lib) fold filterAttrs hasSuffix mapAttrs' nameValuePair removeSuffix
    recursiveUpdate genAttrs;

  # mapFilterAttrs ::
  #   (name -> value -> bool )
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = seive: f: attrs: filterAttrs seive (mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: listToAttrs (map f values);

  # pkgImport :: Nixpkgs -> Overlays -> System -> Pkgs
  pkgImport = nixpkgs: overlays: system:
    import nixpkgs {
      inherit system overlays;
      config = { allowUnfree = true; };
    };

  # Convert a list to file paths to attribute set
  # that has the filenames stripped of nix extension as keys
  # and imported content of the file as value.
  #
  pathsToImportedAttrs = paths:
    genAttrs' paths (path: {
      name = removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });

  overlayPaths =
    let
      overlayDir = ../overlays;
      fullPath = name: overlayDir + "/${name}";
    in
    map fullPath (attrNames (readDir overlayDir));

in
{
  inherit mapFilterAttrs genAttrs' pkgImport pathsToImportedAttrs;

  overlays = pathsToImportedAttrs overlayPaths;

  recImport = { dir, _import ? base: import "${dir}/${base}.nix" }:
    mapFilterAttrs
      (_: v: v != null)
      (n: v:
        if n != "default.nix" && hasSuffix ".nix" n && v == "regular"
        then
          let name = removeSuffix ".nix" n; in nameValuePair (name) (_import name)
        else
          nameValuePair ("") (null))
      (readDir dir);

  nixosModules =
    let
      # binary cache
      cachix = import ../cachix.nix;
      cachixAttrs = { inherit cachix; };

      # modules
      moduleList = import ../modules/list.nix;
      modulesAttrs = pathsToImportedAttrs moduleList;

      # profiles
      profilesList = import ../profiles/list.nix;
      profilesAttrs = { profiles = pathsToImportedAttrs profilesList; };
    in
    recursiveUpdate
      (recursiveUpdate cachixAttrs modulesAttrs)
      profilesAttrs;

  genPackages = { self, pkgs }:
    let
      inherit (self) overlay overlays;
      packagesNames = attrNames (overlay null null)
        ++ attrNames (fold
        (attr: sum: recursiveUpdate sum attr)
        { }
        (attrValues
          (mapAttrs (_: v: v null null) overlays)
        )
      );
    in
    fold
      (key: sum: recursiveUpdate sum {
        ${key} = pkgs.${key};
      })
      { }
      packagesNames;
}

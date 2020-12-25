{ lib, ... }:
let
  inherit (builtins) attrNames isAttrs readDir listToAttrs;

  inherit (lib) filterAttrs hasSuffix mapAttrs' nameValuePair removeSuffix
    recursiveUpdate genAttrs;

  # mapFilterAttrs ::
  #   (name -> value -> bool )
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = seive: f: attrs: filterAttrs seive (mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: listToAttrs (map f values);

  pkgImport = { pkgs, system, overlays }:
    import pkgs {
      inherit system overlays;
      config = { allowUnfree = true; };
    };

  # Convert a list to file paths to attribute set
  # that has the filenames stripped of nix extension as keys
  # and imported content of the file as value.
  pathsToImportedAttrs = paths:
    genAttrs' paths (path: {
      name = removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });

in
{
  inherit mapFilterAttrs genAttrs' pkgImport pathsToImportedAttrs;

  genPkgset = { master, nixos, overlays, system }:
    {
      osPkgs = pkgImport {
        inherit system overlays;
        pkgs = nixos;
      };

      unstablePkgs = pkgImport {
        inherit system overlays;
        pkgs = master;
      };
    };

  overlayPaths =
    let
      overlayDir = ../overlays;
      fullPath = name: overlayDir + "/${name}";
    in
    map fullPath (attrNames (readDir overlayDir));

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

  modules =
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

  genPackages = { overlay, overlays, pkgs }:
    let
      packages = overlay pkgs pkgs;
      overlays' = lib.filterAttrs (n: v: n != "pkgs") overlays;
      overlayPkgs =
        genAttrs
          (attrNames overlays')
          (name: (overlays'."${name}" pkgs pkgs)."${name}");
    in
    recursiveUpdate packages overlayPkgs;

}

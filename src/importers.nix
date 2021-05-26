{ lib, devshell }:
let
  rakeLeaves =
    /**
      Synopsis: rakeLeaves _path_

      Recursively collect the nix files of _path_ into attrs.

      Output Format:
      An attribute set where all `.nix` files and directories with `default.nix` in them
      are mapped to keys(file with .nix stripped or folder name. All other directories
      are recursed further into nested attribute sets with the same format.

      Example file structure:
      ```
      ./core/default.nix
      ./base.nix
      ./main/dev.nix
      ./main/os/default.nix
      ```
      Example output:
      ```
      {
      core = ./core;
      base = base.nix;
      main = {
      dev = ./main/dev.nix;
      os = ./main/os;
      };
      }
      ```
      **/
    dirPath:
    let
      # Relative paths cause issues, so convert to string immediately
      dir = toString dirPath;

      collect = file: type: {
        name = lib.removeSuffix ".nix" file;
        value = let path = "${dir}/${file}"; in
          if (type == "regular")
            || (type == "directory" && builtins.pathExists "${path}/default.nix")
          then path
          else rakeLeaves path;
      };

      files = lib.filterAttrs
        (file: type:
          # Only include `.nix` files or directories
          (type == "regular" && lib.hasSuffix ".nix" file) || (type == "directory")
        )
        (lib.safeReadDir dir);
    in
    lib.mapAttrs' collect files;

  # DEPRECATED, prefer rakeLeaves
  mkProfileAttrs =
    /**
      Synopsis: mkProfileAttrs _path_
      Recursively collect the subdirs of _path_ containing a default.nix into attrs.
      This sets a contract, eliminating ambiguity for _default.nix_ living under the
      profile directory.
      Example:
      let profiles = mkProfileAttrs ./profiles; in
      assert profiles ? core.default; 0
      **/
    dir:
    let
      imports =
        let
          files = lib.safeReadDir dir;

          p = n: v:
            v == "directory"
            && n != "profiles";
        in
        lib.filterAttrs p files;

      f = n: _:
        lib.optionalAttrs
          (lib.pathExists "${dir}/${n}/default.nix")
          { default = "${dir}/${n}"; }
        // mkProfileAttrs "${dir}/${n}";
    in
    lib.mapAttrs f imports;

  getProfilePath = fallback: item:
    if lib.isString item then item else fallback;
in
{
  inherit rakeLeaves;

  mkProfileAttrs = builtins.trace ''
    The function, mkProfileAttrs, has been deprecated, you can now create profile sets
    with the standard importer, rakeLeaves. The formmat of rakeLeaves is a little different,
    because it doesn't recurse into directories with `default.nix` files in them. So some
    of your sub-profiles might no longer be collected. Make sure to update your profiles
    with that in mind;
    See https://github.com/divnix/digga/pull/29 for more details
  ''
    mkProfileAttrs;

  # DEPRECATED, both versions of `profileMap` are no longer necessary
  # paths are type-checked for suites in evalArgs
  # and `.default` isn't special with `rakeLeaves`
  /** profileMap = list: map
    (p: getProfilePath (throw "passed profile ${builtins.toJSON p} isn't a path") p)
    (lib.flatten list); **/
  profileMap = list: map (profile: profile.default) (lib.flatten list);

  overlays = dir:
    {
      # Meant to output a module that sets the overlays option
      # Only get top-level .nix files or default.nix from directories
      overlays = map (getProfilePath (_: _: { })) (builtins.attrValues (rakeLeaves dir));
    };

  hosts = dir:
    {
      # Meant to output a module that sets the hosts option
      hosts = lib.mapAttrs
        (n: p: {
          # Only get top-level .nix files or default.nix from directories
          modules = getProfilePath { } p;
        })
        (rakeLeaves dir);
    };

  maybeImportDevshellModule = item:
    let isPath = builtins.isPath item || builtins.isString item; in
    if isPath && lib.hasSuffix ".toml" item then
      devshell.lib.importTOML item
    else if isPath && lib.hasSuffix ".nix" then
      import item
    else item;

}


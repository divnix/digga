{ lib, devshell }:
let
  flattenTree =
    /**
      Synopsis: flattenTree _tree_

      Flattens a _tree_ of the shape that is produced by rakeLeaves.

      Output Format:
      An attrset with names in the spirit of the Reverse DNS Notation form
      that fully preserve information about grouping from nesting.

      Example input:
      ```
      {
        a = {
          b = {
            c = <path>;
          };
        };
      }
      ```

      Example output:
      ```
      {
        "a.b.c" = <path>;
      }
      ```
    **/
    tree:
    let
      op = sum: path: val:
        let
          pathStr = builtins.concatStringsSep "." path; # dot-based reverse DNS notation
        in
        if builtins.isPath val then
        # builtins.trace "${toString val} is a path"
          (sum // {
            "${pathStr}" = val;
          })
        else if builtins.isAttrs val then
        # builtins.trace "${builtins.toJSON val} is an attrset"
        # recurse into that attribute set
          (recurse sum path val)
        else
        # ignore that value
        # builtins.trace "${toString path} is something else"
          sum
      ;
    
      recurse = sum: path: val:
        builtins.foldl'
          (sum: key: op sum (path ++ [ key ]) val.${key})
          sum
          (builtins.attrNames val)
      ;
    in
    recurse { } [ ] tree;

  rakeLeaves =
    /**
      Synopsis: rakeLeaves _path_

      Recursively collect the nix files of _path_ into attrs.

      Output Format:
      An attribute set where all `.nix` files and directories with `default.nix` in them
      are mapped to keys that are either the file with .nix stripped or the folder name.
      All other directories are recursed further into nested attribute sets with the same format.

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
      seive = file: type:
        # Only rake `.nix` files or directories
        (type == "regular" && lib.hasSuffix ".nix" file) || (type == "directory")
      ;

      collect = file: type: {
        name = lib.removeSuffix ".nix" file;
        value =
          let
            path = dirPath + "/${file}";
          in
            if (type == "regular")
              || (type == "directory" && builtins.pathExists (path + "/default.nix"))
            then path
            # recurse on directories that don't contain a `default.nix`
            else rakeLeaves path;
      };
    in
    lib.mapAttrs' collect (lib.filterAttrs seive (builtins.readDir dirPath));

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
          files = builtins.readDir dir;

          p = n: v:
            v == "directory"
            && n != "profiles";
        in
        lib.filterAttrs p files;

      f = n: _:
        lib.optionalAttrs
          (lib.pathExists (dir + "/${n}/default.nix"))
          { default = dir + "/${n}"; }
        // mkProfileAttrs (dir + "/${n}");
    in
    lib.mapAttrs f imports;

in
{
  inherit rakeLeaves flattenTree;

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
      overlays = builtins.attrValues (flattenTree (rakeLeaves dir));
    };

  hosts = dir:
    {
      # Meant to output a module that sets the hosts option (including constructed host names)
      hosts = lib.mapAttrs
        (n: v: { modules = [ v ]; } )
        (flattenTree (rakeLeaves dir));
    };

  maybeImportDevshellModule = item:
    let isPath = builtins.isPath item || builtins.isString item; in
    if isPath && lib.hasSuffix ".toml" item then
      devshell.lib.importTOML item
    else if isPath && lib.hasSuffix ".nix" then
      import item
    else item;

}


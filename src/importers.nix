{ lib }:
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

  getProfilePath = fallback: item:
    if lib.isString item then item else fallback;
in
{
  inherit rakeLeaves;

  profileMap = list: map
    (p: getProfilePath (throw "passed profile ${builtins.toJSON p} isn't a path") p)
    (lib.flatten list);

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
}


{ lib, ... }:

let mkProfileAttrs =
  /**
  Synopsis: mkProfileAttrs _path_

  Recursively collect the subdirs of _path_ containing a default.nix into attrs.
  This sets a contract, eliminating ambiguity for _default.nix_ living under the
  profile directory.

  Example:
  let profiles = mkProfileAttrs ./profiles; in
  assert profiles ? core.default; 0

  Example folder layout:
  profiles/core/default.nix
  profiles/core/sub/default.nix
  profiles/code/ignored-no-default-nix/
  profiles/other/default.nix

  Example result:
  {
    core = { default = "..." };
    sub = { default = "..." };
    other = { default = "..." };
  }
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
        (lib.pathExists "${dir}/${n}/default.nix")
        { default = "${dir}/${n}"; }
      // mkProfileAttrs "${dir}/${n}";
  in
  lib.mapAttrs f imports;
in mkProfileAttrs


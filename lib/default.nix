args@{ nixos, pkgs, ... }:
let inherit (nixos) lib; in
lib.makeExtensible (self:
  let callLibs = file: import file
    ({
      inherit lib;

      dev = self;
    } // args);
  in
  with self;
  {
    inherit callLibs;

    attrs = callLibs ./attrs.nix;
    os = callLibs ./devos;
    lists = callLibs ./lists.nix;
    strings = callLibs ./strings.nix;

    inherit (attrs) mapFilterAttrs genAttrs' pathsToImportedAttrs concatAttrs;
    inherit (lists) pathsIn;
    inherit (strings) rgxToString;
  })

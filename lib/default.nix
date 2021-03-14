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

    inherit (attrs) mapFilterAttrs genAttrs' pathsToImportedAttrs concatAttrs;
    inherit (lists) pathsIn;
  })

args@{ nixos, pkgs, ... }:
let inherit (nixos) lib; in
lib.makeExtensible (self:
  let callLibs = file: import file
    {
      inherit args lib;
      #
      dev = self;
    };
  in
  with self;
  {
    attrs = callLibs ./attrs.nix;
    os = callLibs ./devos.nix;
    strings = callLibs ./strings.nix;
    lists = callLibs ./lists.nix;

    inherit (attrs) mapFilterAttrs genAttrs' pathsToImportedAttrs concatAttrs;
    inherit (strings) mkVersion;
    inherit (lists) pathsIn;
  })

args@{ nixos, pkgs, self, ... }:
let inherit (nixos) lib; in
lib.makeExtensible (final:
  let callLibs = file: import file
    ({
      inherit lib;

      dev = final;
    } // args);
  in
  with final;
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

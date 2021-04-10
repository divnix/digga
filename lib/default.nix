args@{ nixos, self, ... }:
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

    mkFlake = callLibs ./mkFlake;

    pkgs-lib = callLibs ./pkgs-lib;

    inherit (attrs) mapFilterAttrs genAttrs' safeReadDir
      pathsToImportedAttrs concatAttrs filterPackages;
    inherit (lists) pathsIn;
    inherit (strings) rgxToString;
  })

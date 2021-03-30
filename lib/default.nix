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
    evalFlakeArgs = callLibs ./mkFlake/evalArgs.nix;

    inherit (attrs) mapFilterAttrs genAttrs' safeReadDir
      pathsToImportedAttrs concatAttrs filterPackages;
    inherit (lists) pathsIn;
    inherit (strings) rgxToString;
  })

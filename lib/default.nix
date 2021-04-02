args@{ nixos, self, ... }: # TODO: craft well-defined api for devos-lib
let
  inherit (nixos) lib;
in lib.makeExtensible (final:
  let
    callLibs = file: import file  ({ lib = final; } // args);
  in
  {
    inherit callLibs;

    attrs = callLibs ./attrs.nix;
    os = callLibs ./devos;
    lists = callLibs ./lists.nix;
    strings = callLibs ./strings.nix;

    mkFlake = callLibs ./mkFlake;
  } //
  with final; {
    inherit (attrs) mapFilterAttrs genAttrs' safeReadDir
      pathsToImportedAttrs concatAttrs filterPackages;
    inherit (lists) pathsIn;
    inherit (strings) rgxToString;
  })

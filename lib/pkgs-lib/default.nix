args@{ lib, dev, utils, nixos, ... }:
lib.genAttrs utils.lib.defaultSystems (system:
  lib.makeExtensible (final:
    let
      pkgs = import nixos { inherit system; };
      callLibs = file: import file
        (args // {
          inherit pkgs system;
          pkgs-lib = final;
        });
    in
    with final;
    {
      inherit callLibs;

      tests = callLibs ./tests;
      shell = callLibs ./shell;
    }
  )
)

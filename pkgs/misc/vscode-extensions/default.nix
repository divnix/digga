{ lib, vscode-utils, sources }:
let
  inherit (vscode-utils) isVscodeExt mkVscodeExtensions;

  vscodeSources = lib.filterAttrs
    (name: ext: if ext ? src then isVscodeExt ext.src.name else false)
    sources;

  baseExtensions = mkVscodeExtensions vscodeSources;
in
baseExtensions

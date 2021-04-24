{ pkgs, lib, ... }:
let
  singleDoc = name: value: ''
    ## ${name}
    ${value.description}
    ${lib.optionalString (value ? type) ''
      *_Type_*:
      ${value.type}
    ''}
    ${lib.optionalString (value ? default) ''
      *_Default_*
      ```
      ${builtins.toJSON value.default}
      ```
    ''}
    ${lib.optionalString (value ? example) ''
      *_Example_*
      ```
      ${value.example}
      ```
    ''}
  '';

  options = (
    lib.mkFlake.evalArgs { nixos = "nixos"; args = { }; }
  ).options;

  processedOptions = (pkgs.nixosOptionsDoc { inherit options; }).optionsNix;

  fullDoc = lib.concatStringsSep "" (lib.mapAttrsToList singleDoc processedOptions);
in
pkgs.writeText "devosOptions.md" fullDoc


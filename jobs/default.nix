{ system ? builtins.currentSystem
, inputs ? import ../ufr-polyfills/flake.lock.nix ./.
}:
let

  nixpkgs = inputs.nixpkgs;
  digga = inputs.digga;
  pkgs = import nixpkgs { inherit system; config = { }; overlays = [ ]; };

in
{

  mkApiReference = let
    inherit (digga.lib.mkFlake { self = {}; inputs = {};}) options;
  in
  pkgs.writeText "mkFlakeOptions.md"
    (
      pkgs.nixosOptionsDoc {
        inherit (pkgs.lib.evalModules { modules = [ options]; } ) options;
      }
    ).optionsMDDoc;

}

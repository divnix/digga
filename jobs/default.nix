{ system ? builtins.currentSystem
, inputs ? import ../ufr-polyfills/flake.lock.nix ./.
}:
let

  nixpkgs = inputs.nixpkgs;
  digga = inputs.digga;
  pkgs = import nixpkgs { inherit system; config = { }; overlays = [ ]; };

in
{

  mkFlakeDoc = pkgs.writeText "mkFlakeOptions.md"
    (
      pkgs.nixosOptionsDoc {
        inherit (digga.lib.mkFlake.evalArgs { args = { }; }) options;
      }
    ).optionsMDDoc;

}

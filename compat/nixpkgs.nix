let
  fetch = import ./fetch.nix;
  nixpkgs = fetch "nixos";
in
nixpkgs

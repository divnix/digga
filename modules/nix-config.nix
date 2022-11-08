{lib, ...}: let
  experimental-features = [
    "flakes"
    "nix-command"
  ];
  substituters = [
    "https://nrdxp.cachix.org" # quality of life cache from our CI
    "https://nix-community.cachix.org"
  ];
  trusted-public-keys = [
    "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
in {
  # package and option is from fup
  nix.generateRegistryFromInputs = lib.mkDefault true;

  # missing merge semantics in this option force us to use extra-* for now
  nix.extraOptions = ''
    extra-experimental-features = ${lib.concatStringsSep " " experimental-features}
    extra-substituters = ${lib.concatStringsSep " " substituters}
    extra-trusted-public-keys = ${lib.concatStringsSep " " trusted-public-keys}
  '';
}

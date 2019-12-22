# this file is an impure recreation of the flake profile currently deployed
# based on the systems hostname. The purpose is so tools which do not yet have
# flake support (e.g `nixos-option`), can work as expected.
{ lib, ... }:
let
  host = lib.fileContents /etc/hostname;
in
{
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
    /etc/nixos/profiles/core.nix
    "/etc/nixos/hosts/${host}.nix"
  ];

  networking.hostName = host;
  nix.nixPath = [
    "nixpkgs=${<nixpkgs>}"
    "nixos-config=/etc/nixos/configuration.nix"
  ];
}

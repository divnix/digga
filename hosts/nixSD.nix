{ lib, pkgs, config, unstableModulesPath, ... }:
{
  imports = [
    # passwd is nixos by default
    ../users/nixos
    # passwd is empty by default
    ../users/root
    (unstableModulesPath + "/installer/cd-dvd/sd-image-aarch64.nix")
  ];

  hardware.enableRedistributableFirmware.enable = lib.mkDefault true;
  hardware.pulseaudio.enable = lib.mkDefault true;
  sound.enable = lib.mkDefault true;

  documentation.enable = false;
  networking.wireless.enable = true;
}

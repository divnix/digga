{ lib, pkgs, config, modulesPath, ... }:
{
  imports = [
    # passwd is nixos by default
    ../users/nixos
    # passwd is empty by default
    ../users/root
    (modulesPath + "/installer/cd-dvd/sd-image-aarch64-new-kernel.nix")
  ];

  hardware.enableRedistributableFirmware.enable = lib.mkDefault true;
  hardware.pulseaudio.enable = lib.mkDefault true;
  sound.enable = lib.mkDefault true;

  documentation.enable = false;
  networking.wireless.enable = true;
}

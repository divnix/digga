{ lib, pkgs, ... }:
let
  inherit (builtins) readFile;
in
{
  imports = [
    ../profiles/games
    ../profiles/misc
    ../profiles/misc/plex.nix
    ../profiles/misc/torrent.nix
    ../users/nrd
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5c0bf17c-6df1-4618-88f8-48a4249adb30";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B361-1241";
    fsType = "vfat";
  };

  fileSystems."/srv" = {
    device = "/dev/disk/by-uuid/2a21bc0b-f30a-4001-8976-f39adf805daa";
    fsType = "xfs";
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.cpu.intel.updateMicrocode = true;

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  networking.networkmanager = {
    enable = true;
  };

  nix.maxJobs = lib.mkDefault 4;
  nix.systemFeatures = [ "gccarch-haswell" ];

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };
}

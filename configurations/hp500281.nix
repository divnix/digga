{ lib, pkgs, ... }:
let
  inherit (builtins) readFile;
in
{
  imports = [
    ../users/nrd
    ../profiles/graphical
    ../profiles/misc
  ];

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

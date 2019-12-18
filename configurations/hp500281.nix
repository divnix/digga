{ lib, ... }:
let
  inherit (builtins) readFile;
in
{
  imports = [
    ../users/nrd.nix
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

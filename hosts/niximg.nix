{ unstableModulesPath, ... }: {
  imports = [
    "${unstableModulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  networking.networkmanager.enable = true;
}

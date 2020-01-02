{
  imports = [
    ./NixOS.nix
  ];

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}

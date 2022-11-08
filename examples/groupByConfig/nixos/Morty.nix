{
  lib,
  pkgs,
  config,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  fileSystems."/" = {device = "/dev/disk/by-label/One";};
  users.users.root.password = "";
}

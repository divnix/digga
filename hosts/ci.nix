{ suites, ... }:
{
  imports = [ ../users/nixos ../users/root ] ++ suites.all;

  security.mitigations.acceptRisk = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}

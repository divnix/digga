{ suites, ... }:
{
  imports = with suites; allProfiles ++ allUsers;

  security.mitigations.acceptRisk = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}

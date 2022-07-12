{ profiles, ... }:
{
  imports = with profiles; [
    core.nixos
    # N.B. Make sure to add your public SSH keys to authorized keys!
    users.root
    # Note that this is different than the usual `primary` user for the sake of
    # a familiar installation UX.
    users.nixos
  ];

  boot.loader.systemd-boot.enable = true;

  # Required, but will be overridden in the resulting installer ISO.
  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}

{ config, pkgs, suites, ... }:

{
  imports = suites.base;

  # On darwin, sudoers/admins are added to the `admin` group, not `wheel` as
  # they would be on Linux.
  nix.trustedUsers = [ "@admin" "sosumi" ];

  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  system.stateVersion = 4;
}

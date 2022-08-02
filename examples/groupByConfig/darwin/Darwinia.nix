{ lib, pkgs, config, suites, ... }: {
  # TODO: remove manually-imported suites and profiles once custom test support
  # is added for darwin
  imports = with suites;
    base;

  # On Darwin, admins are added to the `admin` group.
  nix.trustedUsers = [ "@admin" "sosumi" ];

  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  system.stateVersion = 4;
}

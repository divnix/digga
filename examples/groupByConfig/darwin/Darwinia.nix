{ config, pkgs, suites, ... }:

{
  imports = suites.base;

  nix.trustedUsers = [ "@admin" "sosumi" ];

  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  system.stateVersion = 4;
}

{ ... }:
let
  inherit (builtins) readFile;
in
{
  imports = [
    ../users/nrd.nix
    ../profiles/graphical
  ];


  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };
}

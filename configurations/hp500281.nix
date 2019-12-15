{ ... }:
let
  inherit (builtins) readFile;
in
{
  imports = [
    ../users/nrd.nix
  ];


  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };
}

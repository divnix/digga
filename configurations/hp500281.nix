{ ... }:
let
  inherit (builtins) readFile;
in
{
  imports = [];


  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };
}

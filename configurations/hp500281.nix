{ ... }:
let
  inherit (builtins) readFile;
in
{
  imports = [
    ../profiles/develop
  ];


  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };
}

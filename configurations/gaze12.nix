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


  users.users.root.hashedPassword =
    readFile
      ../secrets/root;
}

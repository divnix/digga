{...}: let
  inherit (default.inputs.nixos) lib;

  host = configs.${hostname} or configs.NixOS;
  configs = default.nixosConfigurations;
  default = (import ../.).defaultNix;
  hostname = lib.fileContents /etc/hostname;
in
  host

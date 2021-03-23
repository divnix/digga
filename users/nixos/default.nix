{ ... }:
{
  home-manager.users.nixos = { suites, ... }: {
    imports = suites.base;
  };

  users.users.nixos = {
    uid = 1000;
    password = "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}

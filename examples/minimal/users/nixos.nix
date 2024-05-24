{hmUsers, ...}: {
  home-manager.users = {inherit (hmUsers) nixos;};

  users.users.nixos = {
    password = "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}

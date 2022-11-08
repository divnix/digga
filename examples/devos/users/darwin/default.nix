{hmUsers, ...}: {
  home-manager.users = {inherit (hmUsers) darwin;};

  users.users.darwin = {
    description = "default";
  };
}

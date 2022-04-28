{ hmUsers, ... }:
{
  # The user profile names defined in `self.home.users` don't need to correspond
  # directly to system usernames. They can, instead, be imported as a module in
  # any `home-manager.users` configuration, allowing for more flexibility.
  home-manager.users.admin = {...}: { imports = [hmUsers.primary]; };

  users.users.admin = {
    description = "default";
  };
}

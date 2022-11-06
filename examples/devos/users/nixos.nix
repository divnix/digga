{ hmUsers, ... }:
{
  # In this profile, the `nixos` system-level user loads the home-manager
  # profile for the `primary` user defined in the flake's
  # `self.home.users.primary` option.
  #
  # The user profile names defined in `self.home.users.<name>` don't need to
  # correspond directly to system-level usernames. They can, instead, be
  # imported as a module in any `home-manager.users` configuration, allowing for
  # more flexibility.
  #
  # Compare with the `primary` system user (in this directory), which uses a
  # simplified (but limited) approach.
  home-manager.users.nixos = {...}: { imports = [hmUsers.primary]; };

  users.users.nixos = {
    # This is the standard password for installation media.
    password = "nixos";
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}

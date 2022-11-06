{ hmUsers, ... }:
{
  users.users.primary = {
    description = "primary administrative user on this machine";
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    # Make sure to change this!
    initialPassword = "nixos";
  };

  # The following home-manager user definition doesn't include any further
  # customization beyond the default `hmUsers.primary` profile, so its
  # implementation can be simplified.
  #
  # Note, however, that the pattern demonstrated in the `nixos` user profile is
  # more flexible in the long run, especially if you want to share the same
  # home-manager profile amongst multiple users with different usernames.
  home-manager.users = { inherit (hmUsers) primary; };
}

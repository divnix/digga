{ users, profiles, userProfiles, ... }:

{
  system = with profiles; rec {
    base = [ core users.nixos users.root ];
  };
  user = with userProfiles; rec {
    base = [ direnv git ];
  };
}

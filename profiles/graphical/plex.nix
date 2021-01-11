{ settings, ... }:
let
  inherit (settings) users;
in
{
  services.plex = {
    enable = true;
    dataDir = "/srv/plex";
    group = "media";
    openFirewall = true;
  };

  users.groups.media.members = [ "plex" ];

  users.users."${users.interactive}".extraGroups = [ "media" ];
}

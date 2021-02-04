{ ... }: {
  services.plex = {
    enable = true;
    dataDir = "/srv/plex";
    group = "media";
    openFirewall = true;
  };

  users.groups.media.members = [ "plex" ];
}

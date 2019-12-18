{ ... }:
{
  services.plex = {
    enable = true;
    dataDir = "/srv/plex";
    openFirewall = true;
  };
}

{ pkgs, ... }: {
  services.postgresql = {
    enable = true;
    dataDir = "/srv/postgres";
    package = pkgs.postgresql_12;
  };
}

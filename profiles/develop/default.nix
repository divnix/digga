{ pkgs, ... }:
{
  imports = [
    ./zsh
    ./kakoune
  ];

  environment.shellAliases = {
    v = "XDG_CONFIG_HOME=/etc/xdg $EDITOR";
  };

  environment.sessionVariables = {
    LESS = "-iFJMRWX -z-4 -x4";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    EDITOR = "kak";
    VISUAL = "kak";
  };

  environment.systemPackages = with pkgs; [
    bzip2
    git-crypt
    htop
    less
    gzip
    file
    lrzip
    ncdu
    p7zip
    tokei
    tig
    unrar
    unzip
    wget
    xz
  ];

  programs.thefuck.enable = true;
}

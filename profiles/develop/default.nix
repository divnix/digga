{ pkgs, ... }:
{
  imports = [
    ./zsh
    ./kakoune
    ./tmux
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
    file
    git-crypt
    gnupg
    htop
    less
    ncdu
    tig
    tokei
    wget
  ];

  programs.thefuck.enable = true;
}

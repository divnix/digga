{ pkgs, ... }:
{
  imports = [
    ./zsh
    ./kakoune
    ./tmux
  ];

  environment.shellAliases = {
    v = "$EDITOR";
  };

  environment.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    EDITOR = "k";
    VISUAL = "k";
  };

  environment.systemPackages = with pkgs; [
    file
    git-crypt
    gnupg
    htop
    less
    ncdu
    pass
    tig
    tokei
    wget
  ];

  programs.thefuck.enable = true;
}

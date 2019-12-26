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
    less
    ncdu
    pass
    tig
    tokei
    wget
  ];

  fonts = {
    fonts = [ pkgs.dejaVuNerdFont ];
    fontconfig.defaultFonts.monospace = [
      "DejaVu Sans Mono Nerd Font Complete Mono"
    ];
  };

  nixpkgs.overlays = let
    font = self: super: {
      dejaVuNerdFont = super.callPackage ../../pkgs/data/fonts/dejavu-nerdfont {};
    };
  in
    [ font ];

  documentation.dev.enable = true;

  programs.thefuck.enable = true;
}

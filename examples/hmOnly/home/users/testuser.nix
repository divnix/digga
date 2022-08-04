{ pkgs, suites, ... }:
let
  name = "Test User";
  email = "test@example.com";
in
{
  imports = suites.shell;

  home.packages = with pkgs; [
    # Provided by emacs-overlay
    emacsPgtk
    # Python packages often fail to build on unstable channels.
    httpie
  ];

  programs.browserpass.enable = true;
  programs.starship.enable = true;
  programs.git = {
    userName = name;
    userEmail = email;
  };

  programs.emacs = {
    enable = true;
    # While you'll probably want to use a native-comp package in the real world,
    # in this example we want to avoid compilation to cut down on time/resources.
    package = pkgs.emacsPgtk;
  };

  home.stateVersion = "22.11";
}


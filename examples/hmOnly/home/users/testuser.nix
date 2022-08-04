{ pkgs, suites, ... }:
let
  name = "Test User";
  email = "test@example.com";
in
{
  imports = suites.shell;

  home.packages = with pkgs; [
    # Python packages often fail to build on unstable channels.
    httpie
  ];

  programs.browserpass.enable = true;
  programs.starship.enable = true;
  programs.git = {
    userName = name;
    userEmail = email;
  };
}


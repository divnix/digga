{ pkgs, suites, ... }:
let
  name = "Test User";
  email = "test@example.com";
in
{
  imports = suites.shell;

  home.packages = [ pkgs.hello ];

  programs.browserpass.enable = true;
  programs.starship.enable = true;
  programs.git = {
    userName = name;
    userEmail = email;
  };
}


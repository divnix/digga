{ config, pkgs, suites, ... }:

{
  imports = with suites;
    base;

  # The `mas` package is included here as a test for platform-specific package
  # support in Digga. Feel free to remove it in your config.
  environment.systemPackages = with pkgs; [mas];
}

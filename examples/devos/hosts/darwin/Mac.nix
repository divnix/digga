{ config, pkgs, suites, ... }:

{
  imports = with suites;
    base;
}

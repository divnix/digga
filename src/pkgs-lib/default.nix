{ lib, deploy, devshell }:
{
  tests = import ./tests { inherit lib; };
  shell = import ./shell { inherit lib devshell deploy; };
}


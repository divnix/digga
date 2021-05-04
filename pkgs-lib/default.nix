{ lib, deploy, devshell }:
{
  tests = import ./tests { inherit lib deploy; };
  shell = import ./shell { inherit lib devshell deploy; };
}


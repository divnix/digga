{ lib, deploy, devshell }:
{
  shell = import ./shell { inherit lib devshell deploy; };
}


{ lib, ... }:
let
  inherit (lib)
    fileContents
    ;
in
{
  imports = [
    ../profiles/develop
  ];

  users.users.nrd = {
    uid = 1000;
    description = "Timothy DeHerrera";
    isNormalUser = true;
    hashedPassword = fileContents ../secrets/nrd;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "adbusers"
    ];
  };
}

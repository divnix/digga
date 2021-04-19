# Suites
Suites provide a mechanism for users to easily combine and name collecitons of
profiles. For good examples, check out the suites defined in the community
[branch](https://github.com/divnix/devos/blob/community/suites/default.nix).

In the future, we will use suites as a mechanism for deploying various machine
types which don't depend on hardware, such as vm's and containers.

They are defined in `profiles/suites.nix`.

## Definition
```nix
rec {
  workstation = [ profiles.develop profiles.graphical users.nixos ];
  mobileWS = workstation ++ [ profiles.laptop ];
}
```

## Usage
`hosts/my-laptop.nix`:
```nix
{ suites, ... }:
{
  imports = suites.mobileWS;
}
```

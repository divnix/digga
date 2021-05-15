# Suites
Suites provide a mechanism for users to easily combine and name collecitons of
profiles. For good examples, check out the suites defined in the community
[branch](https://github.com/divnix/devos/blob/community/suites/default.nix).

In the future, we will use suites as a mechanism for deploying various machine
types which don't depend on hardware, such as vm's and containers.

They are defined with the `suites` argument in either `home` or `nixos` namespace.
Suites should be passed as a function that take profiles as an argument.

The profiles are passed based on the folder names and list passed to the relevant
`profiles` argument. In the template's flake.nix `profiles` is set as
`[ ./profiles ./users ]` and that corresponds to the `{ profiles, users }` argument
pattern.

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

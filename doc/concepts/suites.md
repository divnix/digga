# Suites
Suites provide a mechanism for users to easily combine and name collecitons of
profiles. For good examples, check out the suites defined in the community branch.

`suites` are a special case of an `importable` which get passed as a special
argument (one that can be use in an `imports` line) to your hosts.

They are defined with the `suites` argument in either the `home` or `nixos` namespace.
Suites should be passed as a function that take profiles as an argument.

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

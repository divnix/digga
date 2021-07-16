# Suites
Suites provide a mechanism for users to easily combine and name collecitons of
profiles.

`suites` are defined in the `importables` argument in either the `home` or `nixos`
namespace. They are a special case of an `importable` which get passed as a special
argument (one that can be use in an `imports` line) to your hosts. All lists defined
in `suites` are flattened and type-checked as paths.

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

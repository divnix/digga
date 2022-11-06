# Suites
Suites provide a mechanism for users to easily combine and name collections of
profiles.

`suites` are defined in the `importables` argument in any of the `nixos`,
`darwin`, or `home` namespaces. They are a special case of an `importable` which
is passed as a special argument (one that can be use in an `imports` line) to
your hosts. All lists defined in `suites` are flattened and type-checked as
paths.

## Definition

```nix
rec {
  workstation = [
    profiles.develop
    profiles.graphical
    users.primary
  ];
  portableWorkstation =
    workstation
    ++ [ profiles.laptop ];
}
```

## Usage

`hosts/my-laptop.nix`:

```nix
{ suites, ... }:
{
  imports = suites.portableWorkstation;
}
```

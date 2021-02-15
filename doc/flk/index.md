# flk command
The devshell for the project incudes a convenient script for managing your
system called `flk`. Each of the following chapters is a reference for one of
its subcommands.

## Rebuild
Without any of the subcommands, `flk` acts as a convenient shortcut for
`nixos-rebuild`:
```sh
flk NixOS build
```

Will build _hosts/NixOS.nix_. You can change out `build` for `switch`, `test`,
etc. Any additional arguments are passed through to the call to
`nixos-rebuild`.

## Usage
```sh
flk help
```

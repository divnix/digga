# update
The `update` subcommand is a simple alias for:
```sh
nix flake update
```
As it sounds, this will update your lock file.

## Updating Package Sources
If you pass directory name then it will update that input if the directory
contains a flake.nix, with an optional arguement to update only a specific
input in the subflake.

For example, you can update any
[package sources](../outputs/pkgs.md#automatic-source-updates) you may have
declared in _pkgs/flake.nix_:
```sh
flk update pkgs
```
or just its _nixpkgs_:
```sh
flk update pkgs nixpkgs
```

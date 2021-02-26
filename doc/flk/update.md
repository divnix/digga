# update
The `update` subcommand is a simple alias for:
```sh
nix flake update --recreate-lock-file --commit-lock-file
```
As it sounds, this will update your lock file, and commit it.

## Updating Package Sources
If you pass an input name then it will only update that input.

For example, you can update any
[package sources](../../pkgs#automatic-source-updates) you may have declared
in _pkgs/flake.nix_:
```sh
flk update srcs
```

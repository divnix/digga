# update
The `update` subcommand is a simple alias for:
```sh
nix flake update --recreate-lock-file --commit-lock-file
```
As it sounds, this will update your lock file, and commit it.

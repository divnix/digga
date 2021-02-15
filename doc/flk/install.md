# install
The `install` subcommand is a simple convenience for `nixos-install`, similar
to the shortcut for `nixos-rebuild`, all additional arguments are passed
through.

## Example
```sh
flk install NixOS
```

This will install _hosts/NixOS.nix_ to /mnt. You can override this directory
using standard `nixos-install` args.

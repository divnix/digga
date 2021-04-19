# Cachix
The system will automatically pull a cachix.nix at the root if one exists.
This is usually created automatically by a `sudo cachix use`. If your more
inclined to keep the root clean, you can drop any generated files in the
`cachix` directory into the `profiles/cachix` directory without further
modification.

For example, to add your own cache, assuming the template lives in /etc/nixos,
by simply running `sudo cachix use yourcache`. Then, optionally, move
`cachix/yourcache.nix` to `profiles/cachix/yourcache.nix`

These caches are only added to the system after a `nixos-rebuild switch`, so it
is recommended to call `cachix use nrdxp` before the initial deployment, as it
will save a lot of build time.

In the future, users will be able to skip this step once the ability to define
the nix.conf within the flake is fully fleshed out upstream.

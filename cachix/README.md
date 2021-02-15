# Cachix
The cachix directory simple captures the output of `sudo cachix use` for the
developers personal cache, as well as the nix-community cache. You can easily
add your own cache, assuming the template lives in /etc/nixos, by simply
running `sudo cachix use yourcache`.

These caches are only added to the system after a `nixos-rebuild switch`, so it
is recommended to call `cachix use nrdxp` before the initial deployment, as it
will save a lot of build time.

In the future, users will be able to skip this step once the ability to define
the nix.conf within the flake is fully fleshed out upstream.

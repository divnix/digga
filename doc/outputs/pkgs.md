# Packages
Similar to [modules](./modules.md), the pkgs directory mirrors the upstream
[nixpkgs/pkgs][pkgs], and for the same reason; if you ever want to upstream
your package, it's as simple as dropping it into the nixpkgs/pkgs directory.

The only minor difference is that, instead of adding the `callPackage` call to
`all-packages.nix`, you just add it the the _default.nix_ in this directory,
which is defined as a simple overlay.

This overlay is set as the default `overlay` output attribute for the flake.
And all the packages are exported via `packages.<system>.<pkg-name>`, for all
the supported systems listed in the package's `meta.platforms` attribute.

And, as usual, every package in the overlay is also available to any NixOS
[host](../concepts/hosts.md).

## Automatic Source Updates
There is the added, but optional, convenience of declaring your sources in
_pkgs/flake.nix_ as an input. You can then access them from the `srcs` package.
This allows updates to be managed automatically by simply
[updating](../flk/update.md#updating-package-sources) the lock file. No
more manually entering sha256 hashes!

As an added bonus, version strings are also generated automatically from either
the flake ref, or the date and git revision of the source.

## Example
pkgs/development/libraries/libinih/default.nix:
```nix
{ stdenv, meson, ninja, lib, srcs, ... }:
let inherit (srcs) libinih; in
stdenv.mkDerivation {
  pname = "libinih";

  # version will resolve to 53, as specified in the final example below
  inherit (libinih) version;

  src = libinih;

  buildInputs = [ meson ninja ];

  # ...
}
```

pkgs/default.nix:
```nix
final: prev: {
  libinih = prev.callPackage ./development/libraries/libinih { };
}
```

pkgs/flake.nix:
```nix
{
  description = "Package sources";

  inputs = {
    libinih.url = "github:benhoyt/inih/r53";
    libinih.flake = false;
  };
}
```

[pkgs]: https://github.com/NixOS/nixpkgs/tree/master/pkgs

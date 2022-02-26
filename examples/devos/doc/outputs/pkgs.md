# Packages
Similar to [modules](./modules.md), the pkgs directory mirrors the upstream
[nixpkgs/pkgs][pkgs], and for the same reason; if you ever want to upstream
your package, it's as simple as dropping it into the nixpkgs/pkgs directory.

The only minor difference is that, instead of adding the `callPackage` call to
`all-packages.nix`, you just add it the the _default.nix_ in this directory,
which is defined as a simple overlay.

All the packages are exported via `packages.<system>.<pkg-name>`, for all
the supported systems listed in the package's `meta.platforms` attribute.

And, as usual, every package in the overlay is also available to any NixOS
[host](../concepts/hosts.md).

Another convenient difference is that it is possible to use 
[nvfetcher](https://github.com/berberman/nvfetcher) to keep packages up to 
date.
This is best understood by the simple example below.

## Example
It is possible to specify sources separately to keep them up to date semi 
automatically.
The basic rules are specified in pkgs/sources.toml:
```toml
# nvfetcher.toml
[libinih]
src.github = "benhoyt/inih"
fetch.github = "benhoyt/inih"
```
After changes to this file as well as to update the packages specified in there run 
nvfetcher (for more details see [nvfetcher](https://github.com/berberman/nvfetcher)).

The pkgs overlay is managed in
pkgs/default.nix:
```nix
final: prev: {
  # keep sources first, this makes sources available to the pkgs
  sources = prev.callPackage (import ./_sources/generated.nix) { };

  # then, call packages with `final.callPackage`
  libinih = prev.callPackage ./development/libraries/libinih { };
}
```

Lastly the example package is in
pkgs/development/libraries/libinih/default.nix:
```nix
{ stdenv, meson, ninja, lib, sources, ... }:
stdenv.mkDerivation {
  pname = "libinih";

  # version will resolve to the latest available on gitub
  inherit (sources.libinih) version src;

  buildInputs = [ meson ninja ];

  # ...
}
```


## Migration from flake based approach
Previous to nvfetcher it was possible to manage sources via a pkgs/flake.nix, the main changes from there are that sources where in the attribute "srcs" (now "sources") and the contents of the sources where slightly different.
In order to switch to the new system, rewrite pkgs/flake.nix to a pkgs/sources.toml file using the documentation of nvfetcher,
add the line that calls the sources at the beginning of pkgs/default.nix, and 
accomodate the small changes in the packages as can be seen from the example.

The example package looked like:

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

pkgs/default.nix:
```nix
final: prev: {
  # then, call packages with `final.callPackage`
  libinih = prev.callPackage ./development/libraries/libinih { };
}
```

pkgs/development/libraries/libinih/default.nix:
```nix
{ stdenv, meson, ninja, lib, srcs, ... }:
let inherit (srcs) libinih; in
stdenv.mkDerivation {
  pname = "libinih";

  # version will resolve to 53, as specified in the flake.nix file
  inherit (libinih) version;

  src = libinih;

  buildInputs = [ meson ninja ];

  # ...
}
```

[pkgs]: https://github.com/NixOS/nixpkgs/tree/master/pkgs

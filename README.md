>Warning: Highly experimental, API __will__ break!
# Introduction

Welcome to DevOS. This project is under construction as a rewrite of my current
NixOS configuration files available [here][old].

The goal is to make everything as general, modular and *maintainable* as possible
to encourage contributions. The ambitious end game is to create a central repository
of useful NixOS modules and device configurations which are more opinionated than
those found in [nixpkgs][nixpkgs], but are applicable/useful to the wider
[NixOS][NixOS] and [Linux][kernel] communities. The hope is to ease the transition
to NixOS and encourage adoption by allowing common hardware and software to be
automatically configured with sane defaults, enabling iteration instead of
starting from scratch with each new device.

This coupled with a strong notion of an *abstract* machine, e.g. `laptop.nix`
or `mobile.nix`. Will allow devices of all types to be up and running with
Linux "right out of the box"!

No more weekends spent working out the kinks in `INSERT_DISTRO_OF_CHOICE`
on every machine aquiry/transition! Just pull in a database containing an
optimal/optimized NixOS "configuration.nix" for your specific hardware
and software. Then customize it to your needs and contribute back any
improvements!

# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.

[nixpkgs]: https://github.com/NixOS/nixpkgs
[NixOS]: https://nixos.org
[kernel]: https://kernel.org
[old]: https://github.com/nrdxp/nixos

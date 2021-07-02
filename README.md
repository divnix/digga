[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)
[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit]
[![Chat](https://img.shields.io/matrix/devos:nixos.org.svg?label=%23devos%3Anixos.org&logo=matrix&server_fqdn=matrix.org)][matrix]

> #### ⚠ Advisory ⚠
> DevOS requires the [flakes][flakes] feature available via an _experimental_
> branch of [nix][nix]. Until nix 2.4 is released, this project
> should be considered unstable.

### Why?
Make an awesome template for NixOS users, with consideration for common tools like [home-manager][home-manager],
[devshell][devshell], and [more](./doc/integrations).

### No. Why _flakes_?
Flakes are a part of an explicit push to improve [Nix's UI](https://github.com/NixOS/nix/blob/master/doc/manual/src/contributing/cli-guideline.md), and have become an intergral part of that effort. 

They also make [Nix expressions](https://nixos.org/manual/nix/unstable/expressions/expression-syntax.html) easier to distribute and reuse with convient [flake references](https://github.com/NixOS/nix/blob/master/src/nix/flake.md#flake-references) for building or using packages, modules, and whole systems.

## Getting Started
Check out the [guide](https://devos.divnix.com/start) to get up and running.
Also, have a look at [_flake.nix_][toc]. If anything is not immediately 
discoverable via "[`digga`][digga]'s [`mkFlake`][mk-flake],
please file a bug report.

### Status: Beta
Although this project has already matured quite a bit, especially through
recent outfactoring of [`digga`][digga], a fair amount of api polishing is still
expected. There are unstable versions (0._x_._x_) to help users keep track
of changes and progress, and a [`develop`](https://github.com/divnix/devos/tree/develop) branch for the brave 😜

## In the Wild
* The original [authors][please]

## Shoulders
This work does not reinvent the wheel. It stands on the [shoulders of the
following giants][giants]:

### :onion: &mdash; like the layers of an onion
- [`divnix/digga`][digga]
- [`gytis-ivaskevicius/flake-utils-plus`][fup]
- [`numtide/flake-utils`][fu]

### :family: &mdash; like family
- [`numtide/devshell`][devshell]
- [`serokell/deploy-rs`][deploy]
- [`NixOS/nixpkgs`][nixpkgs]

:heart:

## Inspiration & Art
- [hlissner/dotfiles][dotfiles]
- [nix-user-chroot](https://github.com/nix-community/nix-user-chroot)
- [Nickel](https://github.com/tweag/nickel)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
- [devshell](https://github.com/numtide/devshell)

## Divnix
The divnix org is an open space that spontaniously formed out of "the Nix".
It is really just a place where otherwise unrelated people a) get
together and b) stuff done.

It's a place to stop "geeking out in isolation" (or within company boundaries),
experiment and learn together and iterate quickly on best practices. That's what it is.

It might eventually become a non-profit if that's not too complicated or if those
goals are sufficiently upstreamed into "the Nix", dissolved.

# License
DevOS is licensed under the [MIT License][mit].

[mk-flake]: https://github.com/divnix/digga/tree/master/src/mkFlake
[nixpkgs]: https://github.com/NixOS/nixpkgs
[deploy]: https://github.com/serokell/deploy-rs
[toc]: https://github.com/divnix/devos/blob/core/flake.nix
[giants]: https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants
[digga]: https://github.com/divnix/digga
[fup]: https://github.com/gytis-ivaskevicius/flake-utils-plus
[fu]: https://github.com/numtide/flake-utils
[devshell]: https://github.com/numtide/devshell
[nix]: https://nixos.org/manual/nix/stable
[mit]: https://mit-license.org
[nixos]: https://nixos.org/manual/nixos/stable
[home-manager]: https://nix-community.github.io/home-manager
[flakes]: https://nixos.wiki/wiki/Flakes
[flake-doc]: https://github.com/NixOS/nix/blob/master/src/nix/flake.md
[core]: https://github.com/divnix/devos
[community]: https://github.com/divnix/devos/tree/community
[dotfiles]: https://github.com/hlissner/dotfiles
[please]: https://github.com/nrdxp/devos/tree/nrd
[matrix]: https://matrix.to/#/#devos:nixos.org

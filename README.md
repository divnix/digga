[![Bors enabled](https://bors.tech/images/badge_small.svg)](https://app.bors.tech/repositories/32678)
[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit]
[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)

> #### ⚠ Advisory ⚠
> DevOS requires the [flakes][flakes] feature available via an _experimental_
> branch of [nix][nix]. Until nix 3.0 is released, this project
> should be considered unstable, though quite usable as flakes have been
> maturing _well_ [for a while](https://github.com/divnix/devos/tree/17713c22d07c54525c728c62060a0428b76dee3b).

# Introduction
DevOS grants a simple template to use, deploy and manage [NixOS][nixos] systems 
for personal and productive use. A sane repository structure is provided,
integrating several popular projects like [home-manager][home-manager],
[devshell][devshell], and [more](./doc/integrations).

Striving for ___nix first™___ solutions with unobstrusive implementations,
a [flake centric][flake-doc] approach is taken for useful conveniences such as
[automatic source updates](./pkgs#automatic-source-updates).

Skip the indeterminate nature of other systems, _and_ the perceived
tedium of bootstrapping Nix. It's easier than you think!

### Status: Beta
Although this project has already matured quite a bit, especially through
recent outfactoring of [`digga`][digga], a fair amount of api polishing is still
expected. There are unstable versions (0._x_._x_) to help users keep track
of changes and progress.

## Getting Started
Check out the [guide](https://devos.divnix.com/start) to get up and running.
Also, have a look at [_flake.nix_][toc]. If anything is not immediately 
discoverable from there through [`digga`][digga] library's [`mkFlake`][mk-flake],
please file a bug report.

## In the Wild
The author maintains his own branch, so you can take inspiration, direction, or
make critical comments about the [code][please]. 😜

## Motivation
NixOS provides an amazing abstraction to manage our environment, but that new
power can sometimes bring feelings of overwhelm and confusion. Having a turing
complete system can easily lead to unlimited complexity if we do it wrong.
Instead, we should have a community consensus on how to manage a NixOS system
and its satellite projects, from which best practices can evolve.

___The future is declarative! 🎉___

## Community Profiles
There are two branches from which to choose: [core][core] and
[community][community]. The community branch builds on core and includes
several ready-made profiles for discretionary use.

Every package and NixOS profile declared in community is uploaded to
[cachix](./integrations/cachix.md), so everything provided is available
without building anything. This is especially useful for the packages that are
[overridden](./concepts/overrides.md) from master, as without the cache,
rebuilds are quite frequent.

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

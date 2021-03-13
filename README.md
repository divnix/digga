[![Bors enabled](https://bors.tech/images/badge_small.svg)](https://app.bors.tech/repositories/32678)
[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit]
[![NixOS 20.09](https://img.shields.io/badge/NixOS-v20.09-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)

> #### ⚠ Advisory ⚠
> DevOS requires the [flakes][flakes] feature available via an _experimental_
> branch of [nix][nix]. Until nix 3.0 is released, this project
> should be considered unstable, though quite usable as flakes have been
> maturing _well_ [for a while](https://github.com/divnix/devos/tree/17713c22d07c54525c728c62060a0428b76dee3b).

# Introduction
DevOS grants a simple way to use, deploy and manage [NixOS][nixos] systems for
personal and productive use. A sane repository structure is provided,
integrating several popular projects like [home-manager][home-manager],
[devshell][devshell], and [more](./doc/integrations).

Stiving for ___nix first™___ solutions with unobstrusive implementations,
a [flake centric][flake-doc] approach is taken for useful conveniences such as
[automatic source updates](./pkgs#automatic-source-updates).

Skip the indeterminate nature of other systems, _and_ the perceived
tedium of bootstrapping Nix. It's easier than you think!

### Status: Alpha
A lot of the implementation is less than perfect, and huge
[redesigns](https://github.com/divnix/devos/issues/152) _will_ happen. There
are unstable versions (0._x_._x_) to help users keep track of changes and
progress.

## Getting Started
Check out the [guide](https://devos.divnix.com/doc/start) to get up and running.

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

## Upstream
I'd love to see this in the nix-community should anyone believe its reached a
point of maturity to be generally useful, but I'm all for waiting until
1.0[#121](https://github.com/divnix/devos/issues/121) to save the cache work,
too.

## Community Profiles
There are two branches from which to choose: [core][core] and
[community][community]. The community branch builds on core and includes
several ready-made profiles for discretionary use.

Every package and NixOS profile declared in community is uploaded to
[cachix](./cachix), so everything provided is available without building
anything. This is especially useful for the packages that are
[overridden](./overrides) from master, as without the cache, rebuilds are
quite frequent.

## Inspiration & Art
- [hlissner/dotfiles][dotfiles]
- [nix-user-chroot](https://github.com/nix-community/nix-user-chroot)
- [Nickel](https://github.com/tweag/nickel)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
- [devshell](https://github.com/numtide/devshell)

# License
DevOS is licensed under the [MIT License][mit].

[nix]: https://nixos.org/manual/nix/stable
[mit]: https://mit-license.org
[nixos]: https://nixos.org/manual/nixos/stable
[home-manager]: https://nix-community.github.io/home-manager
[flakes]: https://nixos.wiki/wiki/Flakes
[flake-doc]: https://github.com/NixOS/nix/blob/master/src/nix/flake.md
[core]: https://github.com/divnix/devos
[community]: https://github.com/divnix/devos/tree/community
[dotfiles]: https://github.com/hlissner/dotfiles
[devshell]: https://github.com/numtide/devshell
[please]: https://github.com/nrdxp/devos/tree/nrd

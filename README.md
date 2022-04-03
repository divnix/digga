[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit]
[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)
[![Chat](https://img.shields.io/badge/chat-join%20us-brightgreen.svg?style=flat&logo=matrix&logoColor=white)](https://matrix.to/#/#devos:nixos.org)


Digga &mdash; slangy German for "good friend" &mdash; is a flake utility library
that helps you declaratively craft and manage all three layers of your system
environment within a single [nix flakes][flakes] repository:

- development shells (via [`numtide/devshell`][devshell]),
- home environments (via [`nix-community/home-manager`][home-manager]), and
- host configurations (via [`NixOS/nixpkgs/nixos`][nixpkgs]).

This library is based on [flake-utils-plus][].

# Status: Beta
Although this project has already matured quite a bit, a fair amount of api polishing is still
expected. There are unstable versions (0._x_._x_) to help users keep track
of changes and progress.

# Usage
The best way to make use of library is with the [Official template][template].
Check out the [guide](./doc/start/index.md) to get up and running.
Also have a look at devos's [_flake.nix_](./examples/devos/flake.nix).
If anything is not immediately discoverable via our [`mkFlake`][mk-flake], please file a bug report.

# Examples
Make sure to check out all the [examples](./examples) to see the different ways
to make use of the digga api.

## In the Wild
You can also see digga being actually used:
* @Pacman99: [Personal](https://gitlab.com/coffeetables/lower), [Server](https://gitlab.com/coffeetables/myrdd)
* [@danielphan2003](https://github.com/danielphan2003/flk) and make sure to also check out [devos-ext-lib](https://github.com/divnix/devos-ext-lib)
* [PubSolarOS](https://git.sr.ht/~b12f/pub-solar-os)
* @montchr: [Dotfield](https://github.com/montchr/dotfield) – including darwin configurations


# Philosophy

In it's `lib.mkFlake` function, _Digga_ implements a well-specified API
interface comprising four API containers that allow you to:

1. configure **nixpkgs channels** including internal and external overlays,

2. define **NixOS hosts** including internal and external NixOS modules as well as
   host defaults that apply to all hosts in the environment,

3. specify **user home environments** including internal and external home-manager
   modules, and

4. setup & combine a series of **devshells** that you like to have available in
   your projects.

## Modules, Profiles & Suites
For NixOS- & home-manager-modules, _Digga_ allows you to distinguish between
_modules_, _profiles_ and _suites_.

- **Modules** are abstract configurations that, while holding the implementation, do not
set any system state.

- **Profiles** are concrete configurations that set system state within the profile domain.

- **Suites** are a composable, clean and discoverable mechanism for profile aggregation.

## Internal Art vs External Art
Overlays and modules can be defined internally coming from your repo or externally
coming from an upstream flake. This distinction serves the library to only export
your own work as the public flake output.

Downstream consumers of your flake can now more easily tell your art apart from
other upstream art.

# Contributing
We encourage contributions of any kind. The simplest way to get involved is to
join the [chat][] or report problems and ideas on the [issue thread][issues].

To craft well thought out APIs we need all the thoughts regarding new ideas.

Pull Requests are just as amazing.

# Why _flakes_?
Flakes are a part of an explicit push to improve [Nix's UX](https://github.com/NixOS/nix/blob/master/doc/manual/src/contributing/cli-guideline.md), and have become an integral part of that effort. 

They also make [Nix expressions](https://nixos.org/manual/nix/unstable/expressions/expression-syntax.html) easier to distribute and reuse with convient [flake references](https://github.com/NixOS/nix/blob/master/src/nix/flake.md#flake-references) for building or using packages, modules, and whole systems.

# Shoulders
This work does not reinvent the wheel. It stands on the [shoulders of the
following giants][giants]:

## :onion: &mdash; like the layers of an onion
- [`gytis-ivaskevicius/flake-utils-plus`](https://github.com/gytis-ivaskevicius/flake-utils-plus)
- [`numtide/flake-utils`](https://github.com/numtide/flake-utils/)

## :family: &mdash; like family
- [`numtide/devshell`](https://github.com/numtide/devshell)
- [`serokell/deploy-rs`](https://github.com/serokell/deploy-rs)
- [`berberman/nvfetcher`](https://github.com/berberman/nvfetcher)
- [`NixOS/nixpkgs`](https://github.com/NixOS/nixpkgs)

:heart:

### Inspiration & Art
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
- [nix-user-chroot](https://github.com/nix-community/nix-user-chroot)
- [Nickel](https://github.com/tweag/nickel)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
- [devshell](https://github.com/numtide/devshell)

# Divnix
The divnix org is an open space that spontaneously formed out of "the Nix".
It is really just a place where otherwise unrelated people work
together and get stuff done.

It's a place to stop "geeking out in isolation" (or within company boundaries).
A place to experiment, learn together, and iterate quickly on best practices.
That's what it is.

It might eventually become a non-profit if that's not too complicated or, if those
goals are sufficiently upstreamed into "the Nix", dissolved.

# License
Digga is licensed under the [MIT License][mit].

[mk-flake]: ./src/mkFlake
[chat]: https://matrix.to/#/#devos:matrix.org
[devshell]: https://github.com/numtide/devshell
[examples]: https://github.com/divnix/digga/tree/main/examples
[flakes]: https://nixos.wiki/wiki/Flakes
[flake-utils-plus]: https://github.com/gytis-ivaskevicius/flake-utils-plus
[home-manager]: https://github.com/nix-community/home-manager
[issues]: https://github.com/divnix/digga/issues
[mit]: https://mit-license.org
[nix]: https://nixos.org/manual/nix/stable
[nixpkgs]: https://github.com/nixos/nixpkgs
[template]: ./examples/devos


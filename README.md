[![Bors enabled](https://bors.tech/images/badge_small.svg)](https://app.bors.tech/repositories/33905)
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

# Usage
The best way to make use of library is with the [Official template][template].

You can also have a look at the different [examples][].

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

# License

Digga is licensed under the [MIT License][mit].

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
[template]: https://github.com/divnix/devos


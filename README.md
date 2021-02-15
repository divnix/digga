# Introduction
Nixflk is a template which grants a simple way to use, deploy and manage
[NixOS][nixos] systems for personal and productive use. It does this by
providing a sane repository structure, integrating several popular projects
like [home-manager][home-manager], setting clear guidelines, offering useful
conveniences, and eliminating boilerplate so you can focus on deploying your
systems.

## Getting Started
Check out the [guide](https://flk.nrdxp.dev/doc/start) to get up and running.

## Motivation
NixOS provides an amazing abstraction to manage our computers, but that new
power can sometimes bring feelings of overwhelm and confusion. Having a turing
complete programming language can add an unlimited potential for complexity if
we do it wrong. Instead, we should have a community consensus on how to manage
a NixOS system — consider this a first attempt.

___The future is declarative! 🎉___

## Community Profiles
There are two branches from which to choose: [core][core] and
[community][community]. The community branch builds on core and includes
several ready-made profiles for discretionary use.

Every package and NixOS profile declared in community is uploaded to
[cachix](./cachix), so everything provided is available without building
anything. This is especially useful for the packages that are
[overridden](./overrides) from master, as without the cache, rebuilds are
quite frequent.

> #### ⚠ Advisory ⚠
> Nixflk leverages the [flakes][flakes] feature available via an _experimental_
> branch of [nix][nix]. Until nix 3.0 is released, this project should be
> considered unstable.

# License
Nixflk is licensed under the [MIT License](https://mit-license.org).

[nix]: https://nixos.org/manual/nix/stable
[nixos]: https://nixos.org/manual/nixos/stable
[home-manager]: https://nix-community.github.io/home-manager
[flakes]: https://nixos.wiki/wiki/Flakes
[core]: https://github.com/nrdxp/nixflk
[community]: https://github.com/nrdxp/nixflk/tree/community

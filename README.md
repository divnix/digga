# Introduction

This project is under construction as a rewrite of my [legacy][old]
NixOS configuration, using the experimental [flakes][rfc] mechanism. Its aim is
to provide a generic template repository, to neatly separate concerns and allow
one to get up and running with NixOS faster. Flakes are still an experimental
feature, but once they finally get merged, even more will become possible,
including nixops support.


#### [Flake Talk][video]

# Usage
Enter a nix-shell either manually or automatically using [direnv][direnv]. This
will set up the exerimental nix features that need to be available to use
[flakes][pr]. A basic `rebuild` command is included in the shell to replace
`nixos-rebuild` for now.

```
Usage: rebuild [host] {switch|boot|test}
```

You can specify one of the host configurations from the [hosts](hosts)
directory. If omitted, it will default to your systems current hostname.

In addtion:
```
rebuild iso
```

Will make a minimal and bootable iso image of the [niximg](hosts/niximg.nix)
configuration. You can customize the image by editing this file.

You can also install the packages declared in [pkgs](pkgs) without needing
to install NixOS. For example:
```
# from top-level
nix profile install ".#packages.x86_64-linux.purs"
```

# Contributing

The purpose of this repository is to allow for simpler modularity and
maintainability than was achieved in a previous effort. Flakes, along with a
standardized structure, make this simple.

## Hosts
Distributions for particular machines should be stored in the [hosts](hosts)
directory. Every file in this directory will be added automatically to the
available NixOS configurations available in the `nixosConfigurations` flake
output. See the [`default.nix`](hosts/default.nix) for implementation details.

## Profiles
More abstract configurations that can be reused by multiple machines should
go in the [profiles](profiles) directory. It's structure is pretty straight
forward. Just have a look to get an idea. Every profile should have a
`default.nix` to easily import it. You can also stick things in the profile's
subdirectory which are not automatically imported by its `default.nix` but are
meant to be manually imported from a host (useful for less common, or
specialized configurations).

In addition, profiles can depend on other profiles. For example, The
[graphical](profiles/graphical) profile depends on [develop](profiles/develop)
simply by importing it in its [`default.nix`](profiles/graphical/default.nix).

## Users
User declaration belongs in the [users](users) directory. Everything related to
your user should be declared here. For convenience, [home-manager][home-manager]
is available automatically for home directory setup.

## Secrets
Anything you wish to keep encrypted goes in the [secrets](secrets) directory.
Be sure to run `git-crypt init`, before committing anything to this repo.
Be sure to check out the [documentation](https://github.com/AGWA/git-crypt) if
your not familiar.

To keep [profiles](profiles) resuable across configurations, secrets should
only be imported from the [users](users) directory.

## Modules and Packages
All [modules](modules/default.nix) and [pkgs](pkgs/default.nix) are available
for every configuration automatically. Simply add a `*.nix` file to one of
these  directories declaring your module or package, and update the
corresponding `default.nix` to point to it. Now you can use your new module or
install your new package as usual.

Doing this will also add them to the flake's `nixosModules` or `overlays`
outputs to import them easily into an external NixOS configuration as well.

## Pull Requests

If you'd like to add a package, module, profile or host configuration please
be sure to format your code with [`nixpkgs-fmt`][nixpkgs-fmt] before
opening a pull-request. The commit message follows the same semantics as
[nixpkgs][nixpkgs]. You can use a `#` symbol to specify abiguities. For example,
`develop#zsh: <rest of commit message>` would tell me that your updating the
`zsh` configuration living under the `develop` profile.


# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.

[direnv]: https://direnv.net
[home-manager]: https://github.com/nrdxp/home-manager
[NixOS]: https://nixos.org
[nixpkgs-fmt]: https://github.com/nix-community/nixpkgs-fmt
[nixpkgs]: https://github.com/NixOS/nixpkgs
[old]: https://github.com/nrdxp/nixos
[pr]:  https://github.com/NixOS/nixpkgs/pull/68897
[rfc]: https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md
[video]: https://www.youtube.com/watch?v=UeBX7Ide5a0

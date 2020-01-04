# Introduction

This project is under construction as a rewrite of my [legacy][old]
NixOS configuration using the experimental [flakes][rfc] mechanism. Its aim is
to provide a generic template repository which neatly separates concerns and
allows one to get up and running with NixOS faster than ever.

Flakes are still an experimental feature, but once they finally get merged,
even more will become possible, including [nixops](https://nixos.org/nixops)
support.


#### [Flake Talk][video]

# Usage

Enter a nix-shell either manually or automatically using [direnv][direnv]. This
will set up the exerimental nix features that need to be available to use
[flakes][pr].

Start a new branch based on the template branch:
```
git checkout -b <new_branch> template
```

You may want to use a generated hardware config for your machine:
```
nixos-generate-config --show-hardware-config > ./hosts/<new_host>.nix
```


A basic `rebuild` command is included in the shell to replace
`nixos-rebuild` for now:

```
Usage: rebuild [host] {switch|boot|test}

#example using above generated config
rebuild <new_host> switch
```

You can specify one of the host configurations from the [hosts](hosts)
directory. If omitted, it will default to your systems current hostname.

And now you should be ready to start writing your nix configuration or import
some of the already existing profiles. Review [contributing](#contributing)
below on how to structure your expressions. And be sure to update the
[locale.nix](local/locale.nix) for your region.

You can always check out my personal branch
[`nrdxp`](https://github.com/nrdxp/nixflk/tree/nrdxp), for concrete examples.

## Additional Capabilities

Making iso images:
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

A similar mechanism exists to import the modules and overlays declared in the
flake to allow for seemless sharing between configurations.

# Contributing

The purpose of this repository is to provide a standardized template structure
for NixOS machine expressions, thus enabling simpler sharing and reuse of nix
expressions.

Say your friend and you are using this repository, each with your own unique
nix epxpressions. By simply importing your friends flake from `flake.nix` as an
input, you can have access to all of the packages, modules, overlays, and even
entire system configurations your friend has defined!

## Hosts
Distributions for particular machines should be stored in the [hosts](hosts)
directory. Every file in this directory will be added automatically to the
the `nixosConfigurations` flake output. See the
[`default.nix`](hosts/default.nix) for the implementation details.

## Profiles
More abstract configurations suitable for reuse by multiple machines should
go in the [profiles](profiles) directory. A distinction is made between a module
and profile, in that a profile is simly a regular NixOS module, without any new
option declarations. If you want to declare new
[options](https://nixos.org/nixos/manual/options.html), create an expression
under the [modules](modules) directory instead.

Every profile should have a `default.nix` to easily import it. You can also
stick things in the profile's subdirectory which are not automatically
imported, but are meant to be manually imported from a host (useful for less
common, or specialized configurations).

Importantly, every subdirectory in a profile should be independantly importable.
For example, a zsh directory lives under [profiles/develop](profiles/develop/zsh).
It's written in a generic way to allow in to be imported without the entire
[develop](profiles/develop) if one so wished. This provides a wonderful level of
granularity.

In addition, profiles can depend on other profiles. For example, The
[graphical](profiles/graphical) profile depends on [develop](profiles/develop)
simply by importing it in its [`default.nix`](profiles/graphical/default.nix).

You can, optionally, choose to export your profiles via the flake output. If
you add an attribute to [profiles/default.nix](profiles/default.nix) named
\<your-profile>, then it will become available to other flakes via
`nixosModules.profiles.<your-profile>`.

## Users
User declaration belongs in the `users` directory. Everything related to
your user should be declared here. For convenience, [home-manager][home-manager]
is available automatically for home directory setup and should only be used
from this directory.

## Secrets
Anything you wish to keep encrypted goes in the `secrets` directory, which is
created on first entering a `nix-shell`.

Be sure to run `git crypt init`, before committing anything to this directory.
Be sure to check out git-crypts [documentation](https://github.com/AGWA/git-crypt)
if your not familiar. The filter is already set up to encrypt everything in this
folder by default.

To keep [profiles](profiles) resuable across configurations, secrets should
only be imported from the `users` directory.

## Modules and Packages
All [modules](modules/default.nix) and [pkgs](pkgs/default.nix) are available
for every configuration automatically. Simply add an expression to one of
these directories declaring your module or package, and update the
corresponding `default.nix` to point to it. Now you can use your new module or
install your new package as usual from any profile.

Doing this will also add them to the flake's `nixosModules` or `overlays`
outputs to import them easily into an external NixOS configuration as well.

## Pull Requests

While much of your work in this template may be idiosyncratic in nature. Anything
that might be generally useful to the broader NixOS community can be synced to
the `template` branch to provide a host of useful NixOS configurations available
"out of the box". If you wish to contribute such an expression please follow
these guidelines:

* format your code with [`nixpkgs-fmt`][nixpkgs-fmt]
* The commit message follows the same semantics as [nixpkgs][nixpkgs].
  * You can use a `#` symbol to specify abiguities. For example,
  `develop#zsh: <rest of commit message>` would tell me that your updating the
  `zsh` subprofile living under the `develop` profile.



# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.

[direnv]: https://direnv.net
[home-manager]: https://github.com/rycee/home-manager
[NixOS]: https://nixos.org
[nixpkgs-fmt]: https://github.com/nix-community/nixpkgs-fmt
[nixpkgs]: https://github.com/NixOS/nixpkgs
[old]: https://github.com/nrdxp/nixos
[pr]:  https://github.com/NixOS/nixpkgs/pull/68897
[rfc]: https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md
[video]: https://www.youtube.com/watch?v=UeBX7Ide5a0

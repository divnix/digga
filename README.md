# Introduction
A NixOS configuration template using the experimental [flakes][rfc] mechanism.
Its aim is to provide a generic repository which neatly separates concerns
and allows one to get up and running with NixOS faster than ever.

Flakes are still an experimental feature, but once they finally get merged
even more will become possible, i.e. [nixops](https://nixos.org/nixops)
support.

#### [Flake Talk][video]

# Usage

```sh
# not needed if using direnv
nix-shell

git checkout -b $new_branch template

# generate hardware config
nixos-generate-config --show-hardware-config > ./hosts/${new_host}.nix


# wrapper for `nix build` bypassing `nixos-rebuild`
# Usage: rebuild [([host] {switch|boot|test|dry-activate})|iso]

# You can specify any of the host configurations living in the ./hosts
# directory. If omitted, it will default to your systems current hostname.
rebuild $new_host switch

```


And now you should be ready to start writing your nix configuration or import
your current one. Review [structure](#structure) below on how to build your
layout. And be sure to update the [locale.nix](local/locale.nix) for your
region.

You can always checkout my personal branch
[`nrdxp`](https://github.com/nrdxp/nixflk/tree/nrdxp) for more concrete examples.

## Additional Capabilities

```sh
# make an iso image based on ./hosts/niximg.nix
rebuild iso

# install any package the flake exports
nix profile install ".#packages.x86_64-linux.myPackage"
```

this flake exports overlays and modules as well:
```nix
# external flake.nix
{
  # ...
  inputs.nixflk.url = "github:nrdxp/nixflk";

  outputs = { self, nixpkgs, nixflk }: {

    nixosConfigurations.myConfig = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nixpkgs.overlays = nixflk.overlays; }
        nixflk.nixosModules.myModule
      ];
    };
  };
}

```

# Structure

The structure is here to keep things simple and clean. Anything sufficiently
generic can ultimately be exported for use in other flakes without getting
tied up in user concerns. An additional bonus of is the ability to trivially
swap or combine [profiles](#profiles).

## Hosts
Distributions for particular machines should be stored in the [hosts](hosts)
directory. Every file in this directory will be added automatically to the
the `nixosConfigurations` flake output and thus deployable. See the
[`default.nix`](hosts/default.nix) for the implementation details.

## Profiles
More abstract expressions suitable for reuse by deployments should live  in the
[profiles](profiles) directory.  A distinction is made between a module and
profile, in that a profile is simply a regular NixOS module, without any _new_
option declarations.

Every directory here is a profile and should have a `default.nix` to import it.
Profiles can have subprofiles which are just subdirectories with a `default.nix`.
There's no hard rule that everything in the folder must be imported by its
`default.nix` so you can also store relevant configurations that may not be used
as often and just import them directly from a [host](#hosts) when needed.

Importantly, every subdirectory in a profile should be independently importable.
For example, a zsh directory lives under [profiles/develop](profiles/develop/zsh).
It's written in a generic way to allow in to be imported without the entire
[develop](profiles/develop) if one so wished. This provides a wonderful level of
granularity.

In addition, profiles can depend on other profiles. For example, The
[graphical](profiles/graphical) profile depends on [develop](profiles/develop)
simply by importing it in its [`default.nix`](profiles/graphical/default.nix).

You can, optionally, choose to export your profiles via the flake output. If
you add it to the list in [profiles/default.nix](profiles/default.nix), then it
will become available to other flakes via `nixosModules.profiles.<filename>`.

## Users
User declaration belongs in the `users` directory. Everything related to
your user should be declared here. For convenience, [home-manager][home-manager]
is available automatically for home directory setup and should only be used
from this directory.

## Secrets
Anything you wish to keep encrypted goes in the `secrets` directory, which is
created on first entering a `nix-shell`.

Be sure to run `git crypt init`, before committing anything to this directory.
Be sure to check out git-crypt's [documentation](https://github.com/AGWA/git-crypt)
if your not familiar. The filter is already set up to encrypt everything in this
folder by default.

To keep [profiles](profiles) reusable across configurations, secrets should
only be imported from the `users` directory.

## Modules and Packages
All [modules](modules/default.nix) and [pkgs](pkgs/default.nix) are available
for every configuration automatically. Simply add an expression to one of
these directories declaring your module or package, and update the
corresponding `default.nix` to point to it. Now you can use your new module or
install your new package as usual from any profile.

Doing this will also add them to the flake's `nixosModules` or `overlays`
outputs to import them easily into an external NixOS configuration as well.

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
[old]: https://github.com/nrdxp/nixos
[pr]:  https://github.com/NixOS/nixpkgs/pull/68897
[rfc]: https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md
[video]: https://www.youtube.com/watch?v=UeBX7Ide5a0

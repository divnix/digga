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


# `rebuild` wrapper for `nix build` bypassing `nixos-rebuild`
# Usage: rebuild [host] {switch|boot|test|dry-activate}

# You can specify any of the host configurations living in the ./hosts
# directory. If omitted, it will default to your systems current hostname.
rebuild $new_host switch

```


And now you should be ready to start writing your nix configuration or import
your current one. Review the [structure](#structure) below on how to build your
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

this flake exports multiple outputs for use in other flakes:
```nix
# external flake.nix
{
  # ...
  inputs.nixflk.url = "github:nrdxp/nixflk";

  outputs = { self, nixpkgs, nixflk }: {

    nixosConfigurations.newConfig = nixflk.nixosConfigurations.someConfig;

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
tied up in user concerns. As an added bonus, one can now trivially swap or
combine [profiles](#profiles), creating a custom config in mere moments.

## Hosts
Distributions for particular machines should be stored in the [hosts](hosts)
directory. Every file in this directory will be added automatically to the
the `nixosConfigurations` flake output and thus becomes deployable. See the
[`default.nix`](hosts/default.nix) for the implementation details.

## Profiles
A profile is any directory under [profiles](profiles) containing a `default.nix`
defining a valid NixOS module, _with_ the added restriction that no new
delclarations to the `options` attribute are allowed (use [modules](modules)
instead). Their purpose is to provide abstract expressions suitable for reuse by
multiple deployments. They are perhaps _the_ key concept in keeping this
repository matainable.

Profiles can have subprofiles which are themselves just profiles that live under
another. There's no hard rule that everything in the folder must be imported by
its `default.nix`, so you can also store relevant code that is useful but not
wanted by default in, say, an `alt.nix`.  Importantly, every subdirectory in a
profile should be independent of its parent.

For example, a zsh directory lives under [profiles/develop](profiles/develop/zsh).
It's self contained to allow inclusion without the whole of
[develop](profiles/develop) if one so wished. This provides a wonderful level of
granularity and control. Put simply: take the best, leave the rest.

In addition, profiles can depend on other profiles. For instance, the
[graphical](profiles/graphical) profile depends on [develop](profiles/develop)
simply by importing it. This is to ensure my terminal configuration is always
available from within a graphical session.

Optionally, you may choose to export your profiles via the flake output. If
you include it in the list defined in [profiles/default.nix](profiles/default.nix),
it will be available to other flakes via `nixosModules.profiles`.

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
only be imported from the `users` or [`hosts`](hosts) directory.

## Modules and Packages
All expressions in both [modules/defualt.nix](modules/default.nix) and
[pkgs/default.nix](pkgs/default.nix) are available globally, anywhere else in the
repo. They are additionally included in the `nixosModules` or `overlays` flake
outputs. Packages can manually be added to [flake.nix](flake.nix) for inclusion
in the `packages` output as well.

The directory structure is identical to nixpkgs to provide a kind of staging area
for any modules or packages we might be wanting to merge there later. If your not
familiar or can't be bothered, simply dropping a valid nix file and pointing the
`default.nix` to it, is all that's really required.

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

# Introduction
A NixOS configuration template using the experimental [flakes][rfc] mechanism.
Its aim is to provide a generic repository which neatly separates concerns
and allows one to get up and running with NixOS faster than ever.

A core goal is to facilitate a (mostly) seamless transition to flakes.
You could start by simply importing your `configuration.nix` from a module
in [hosts](hosts). There may be some translation if you import anything
from the `NIX_PATH`, e.g. `import <nixpkgs> {}`, but the majority of any valid
NixOS config should work right out of the box. Once your up and running, you
may wish to modify your configuration to adhere to the [ideals](DOC.md) of this
project.

### ⚠ Advisory
Flakes are still an experimental feature, so not everything works yet.
Things like [nixops](https://nixos.org/nixops)/[disnix](https://nixos.org/disnix)
are not yet supported.

Also, flakes are meant to deprecate nix-channels. I'd recommend not
installing any. If your really want them, they should work if you hook them
into your `NIX_PATH` manually.

## Flake Talk:
[![Flake talk at NixConf][thumb]][video]


# Setup

```sh
# This is not needed if your using direnv:
nix-shell

# It's recommend to start a new branch:
git checkout -b $new_branch template

# Generate a hardware config:
nixos-generate-config --show-hardware-config > ./hosts/${new_host}.nix

# Edit the new file, removing `not-detected.nix` from the imports.
# In order to maintain purity flakes cannot resolve from the NIX_PATH.

# You could import your existing `configuration.nix`, or the generic
# `./hosts/NixOS.nix` from here. The latter sets up Network Manger,
# an efi bootloader, an empty root password, and a generic user
# named `nixos`.

# Also ensure your file systems are set the way you want:
$EDITOR ./hosts/${new_host}.nix

# Backup your existing config:
mv /etc/nixos /etc/nixos.old

# Ensure this flake can be found in its expected location:
ln -s $PWD /etc/nixos

# A flake is vcs based, so only git aware files are bundled
# adding a new file to staging is enough:
git add ./hosts/${new_host}.nix

# A generic `rebuild` wrapper for `nix build` is provided
# bypassing the need for `nixos-rebuild`.

# Usage: rebuild [host] {switch|boot|test|dry-activate}
# where `host` is any file living in the `./hosts` directory

# Test your new deployment; this will be run as root:
rebuild $new_host test

# You may wish to start by creating a user:
mkdir users/new-user && $EDITOR users/new-user/default.nix

# Once your satisfied, permanently deploy with:
rebuild $new_host switch
```

Please read the [doc](DOC.md) in order to understand the impetus
behind the directory structure.

## Additional Capabilities

```sh
# Make an iso image based on `./hosts/niximg.nix`:
rebuild iso

# Install any package the flake exports:
nix profile install ".#packages.x86_64-linux.myPackage"
```

this flake exports multiple outputs for use in other flakes, or forks
of this one:
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

### NUR usage

You can use packages, modules and overlays from the
[Nix User Repository][nur].

Since NUR packages are completely unchecked, they are not included by default.
Check out the NUR [branch](https://github.com/nrdxp/nixflk/tree/NUR#nur-usage)
for usage.

# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.

[direnv]: https://direnv.net
[NixOS]: https://nixos.org
[nur]: https://github.com/nix-community/NUR
[old]: https://github.com/nrdxp/nixos
[pr]:  https://github.com/NixOS/nixpkgs/pull/68897
[rfc]: https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md
[video]: https://www.youtube.com/watch?v=UeBX7Ide5a0
[thumb]: https://img.youtube.com/vi/UeBX7Ide5a0/hqdefault.jpg

# Introduction
A NixOS configuration template using the experimental [flakes][rfc] mechanism.
Its aim is to provide a generic repository which neatly separates concerns
and allows one to get up and running with NixOS faster than ever.

Please be advised, flakes are still an experimental feature.
Presuming they get [merged][rfc], even more will become possible, e.g.
[nixops](https://nixos.org/nixops)/[disnix](https://nixos.org/disnix)
support.

#### Flake Talk:
[![Flake talk at NixConf][thumb]][video]

Keep in mind that flakes are meant to deprecate nix-channels. I'd recommend not
installing any. If your really want them, they should work if you wire them
up with your `NIX_PATH`.

# Setup

```sh
# not needed if using direnv
nix-shell

git checkout -b $new_branch template

# set a root password, preferably with `hashedPassword`
$EDITOR ./users/root/default.nix

# generate hardware config
nixos-generate-config --show-hardware-config > ./hosts/${new_host}.nix

# Edit the new file, removing `not-detected.nix` from the imports.
# In order to maintain purity flakes cannot resolve from the NIX_PATH.
# You may also want to import ./hosts/NixOS.nix from here which sets up
# an efi bootloader, enables Network Manager and sets an empty root password.
# Otherwise you'll need to set the bootloader, network and password yourself.

# Also ensure your file systems are set the way you want. And import
# any ./profiles you may wish to try out.
$EDITOR ./hosts/${new_host}.nix

# backup existing config and ensure configuration lives in expected location
mv /etc/nixos /etc/nixos.old
ln -s $PWD /etc/nixos

# a flake is vcs based, so only git aware files are bundled
# adding a new file to staging is enough
git add ./hosts/${new_host}.nix

# `rebuild` wrapper for `nix build` bypassing `nixos-rebuild`
# Usage: rebuild [host] {switch|boot|test|dry-activate}

# You can specify any of the host configurations living in the ./hosts
# directory. If omitted, it will default to your systems current hostname.
# This will be run as root.
rebuild $new_host switch

# you may wish to start by creating a user
mkdir users/new-user && $EDITOR users/new-user/default.nix
```

Best to read the [doc](DOC.md), in order to understand the impetus behind
the directory structure.


## Additional Capabilities

```sh
# make an iso image based on ./hosts/niximg.nix
rebuild iso

# install any package the flake exports
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

# Introduction
Herein lies a [NixOS][NixOS] configuration template using the new [flakes][wiki]
mechanism. Its aim is to provide a generic repository which neatly separates
concerns and allows one to get up and running with NixOS faster than ever, while
keeping your code clean and organized.

Some key advantages include:
* A single home for all your Nix expressions, easily sharable and portable!
* Skip the setup, simply use the included [nix-shell](./shell.nix) or
  [direnv][direnv] profile and get up and running with flakes right away.
* Thanks to flakes, the entire system is more [deterministic](./flake.lock).
* Systems defined under [hosts](./hosts) are automatically imported into
  `nixosConfigurations`, ready to deploy.
* [Profiles](./profiles/list.nix) are a simple mechanism for using portable
  code across machines, and are available to share via the
  `nixosModules.profiles` output.
* Defined [packages](./pkgs/default.nix) and
  [modules](./modules/list.nix), are automatically wired and available from
  anywhere. They are _also_ sharable via their respective flake outputs.
* Easily [override](./pkgs/override.nix) packages from different nixpkgs versions.
* Keep [user](./users) configuration isolated and easily reusable by taking
  advantage of [user profiles](./users/profiles) and [home-manager][home-manager].
* [Overlay](./overlays) files are automatically available and sharable.

For a more detailed explanation of the code structure, check out the
[docs](./DOC.md).

### ⚠ Advisory
Flakes are still new, so not everything works yet. However, it has been to
merged in [nixpkgs][nixpkgs] via [`pkgs.nixFlakes`][nixFlakes]. Thus, this
project should be considered _experimental_, until flakes become the default.

Also, flakes are meant to deprecate nix-channels. It's recommend not to install
any. If your really want them, they should work if you hook them into
`NIX_PATH`.

# Setup
There are many way to get up and running. You can fork this repo or use it as
a template. There is a [bare branch][bare] if you want to start with a
completely empty template and make your own profiles from scratch.

You'll need to have NixOS already installed since the `nixos-install` script
doesn't yet support flakes.

If you already have [nix-command][nix-command] setup you can:
```
# for standard template
nix flake new -t "github:nrdxp/nixflk" flk

# for bare template
nix flake new -t "github:nrdxp/nixflk/bare" flk
```

However you decide to acquire the repo, once you have it, you'll want to __move
or symlink__ it to `/etc/nixos` for ease of use. Once inside:

```
nix-shell # or `direnv allow` if you prefer
```

From here it's up to you. You can deploy the barebones [NixOS](./hosts/NixOS.nix)
host and build from there, or you can copy your existing `configuration.nix`.
You'll probably at least need to setup your `fileSystems` and make sure the
[locale](./local/locale.nix) is correct.

Once you're ready to deploy you can use `nixos-rebuild` if your NixOS version
is recent enough to support flakes, _or_ the [shell.nix](./shell.nix) defines
its own `rebuild` command in case you need it.

```
# Usage: rebuild host {switch|boot|test|iso}
rebuild <host-filename> test
```

## Build an ISO

You can make an ISO and customize it by modifying the [niximg](./hosts/niximg.nix)
file:

```sh
rebuild iso
```

## Flake Talk:
[![Flake talk at NixConf][thumb]][video]

# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.

[bare]: https://github.com/nrdxp/nixflk/tree/bare
[direnv]: https://direnv.net
[home-manager]: https://github.com/rycee/home-manager
[nix-command]: https://nixos.wiki/wiki/Nix_command
[nixFlakes]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/package-management/nix/default.nix#L211
[NixOS]: https://nixos.org
[nixpkgs]: https://github.com/NixOS/nixpkgs
[nur]: https://github.com/nix-community/NUR
[wiki]: https://nixos.wiki/wiki/Flakes
[thumb]: https://img.youtube.com/vi/UeBX7Ide5a0/hqdefault.jpg
[video]: https://www.youtube.com/watch?v=UeBX7Ide5a0

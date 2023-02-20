# Quick Start

The only dependency is nix, so make sure you have it [installed][install-nix].

## Get a Template

If you currently don't have flakes support, you can temporarily enable them:

```sh
nix flake init --experimental-features 'nix-command flakes' -t github:divnix/digga
```

If you already have flakes support, you can simply pull the template:

```sh
nix flake init -t github:divnix/digga
```

Make sure to create the git repository:

```sh
git init
git add .
git commit
```

Finally, run `nix-shell` to get to an interactive shell with all the
dependencies, including the unstable nix version required. You can run `menu` to
confirm that you are using digga (expected output includes [docs], [general
commands], [linter], etc.).

In addition, the [binary cache](../integrations/cachix.md) is added for faster deployment.

> # _Notes:_
>
> - Flakes ignore files that are not tracked by git, so be sure to stage new
>   files before building the system.
> - You can choose to simply clone the repo with git if you want to follow
>   upstream changes.
> - There are other templates. The default is `devos`, which is opinionated and
>   implements the most features. Other templates can be found with
>   `nix flake show` or by viewing Digga's flake.nix. Other templates can be
>   used with `nix flake init -t github:divnix/digga#<templateName>`

## Next Steps

- [Make an installable ISO](./iso.md)

[install-nix]: https://nixos.org/manual/nix/stable/#sect-multi-user-installation

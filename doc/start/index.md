# Quick Start
The only dependency is nix, so make sure you have it [installed][install-nix].

## Get the Template
If you currently don't have flakes setup, you can utilize the digga shell to pull the template:
```sh
nix-shell "https://github.com/divnix/digga/archive/main.tar.gz" \
  --run "nix flake init -t github:divnix/digga"
```
If you already have flakes support, you can directly pull the template:
```sh
nix flake init -t github:divnix/digga
```

Then make sure to create the git repository:
```sh
git init
git add .
git commit -m init
```

To drop into a nix-shell, if you don't have flakes setup, use the digga shell to create a `flake.lock`:
```sh
nix-shell "https://github.com/divnix/digga/archive/main.tar.gz" \
  --run "nix flake lock"
```
Or if you do have flakes support, just run:
```sh
nix flake lock
```

Finally, run `nix-shell` to get to an interactive shell with all the dependencies, including the unstable nix
version required. You can run `menu` to confirm that you are using digga (expected output includes [docs], [general commands], [linter], etc.).

In addition, the [binary cache](../integrations/cachix.md) is added for faster deployment.

> ##### _Notes:_
> - Flakes ignore files that have not been added to git, so be sure to stage new
>   files before building the system.
> - You can choose to simply clone the repo with git if you want to follow
>   upstream changes.
> - If the `nix-shell -p cachix --run "cachix use nrdxp"` line doesn't work
>   you can try with sudo: `sudo nix-shell -p cachix --run "cachix use nrdxp"`

## Next Steps:
- [Make installable ISO](./iso.md)
- [Bootstrap Host](./bootstrapping.md)
- [Already on NixOS](./from-nixos.md)


[install-nix]: https://nixos.org/manual/nix/stable/#sect-multi-user-installation

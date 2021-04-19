# Overrides
By default, the NixOS systems are based on unstable. While it is trivial to
change this to a stable release, or any other branch of nixpkgs by
changing the flake url, sometimes all we want is a single package from another
branch.

This is what the overrides are for. By default, they are pulled directly from
nixpkgs/master, but you can change the `override` flake input url to
nixos-unstable, or even a specific sha revision.

They are defined in the `extern/overrides.nix` file.

## Example

### Packages
The override packages are defined as a regular overlay with an extra arguement
`pkgs`. This refers to the packages built from the `override` flake.

Pulling the manix package from the override flake:
```nix
{
  packages = pkgs: final: prev: {
    inherit (pkgs) manix;
  };
}
```

### Modules

You can also pull modules from override. Simply specify their path relative to
the nixpkgs [modules][nixpkgs-modules] directory. The old version will be added
to `disabledModules` and the new version imported into the configuration.

Pulling the zsh module from the override flake:
```nix
{
  modules = [ "programs/zsh/zsh.nix" ];
}
```

> ##### _Note:_
> Sometimes a modules name will change from one branch to another. This is what
> the `disabledModules` list is for. If the module name changes, the old
> version will not automatically be disabled, so simply put it's old name in
> this list to disable it.

[nixpkgs-modules]: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules

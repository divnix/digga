# Overrides
Each NixOS host follows one channel. But many times it is useful to get packages
or modules from different channels.

This is what the overrides are for. You can make use of the `overrides.nix` to
override specific packages to be pulled from other channels. Any overlay may get
`channels` as their first argument.

## Example

### Packages
The override packages are defined as a regular overlay with an extra arguement
`channels`. This refers to all channels defined in `flake.nix`.

Pulling the manix package from the latest flake:
```nix
channels: final: prev: {
  inherit (pkgs.latest) manix;
}
```

### Modules

You can also pull modules from other channels. All modules have access to the 
`modulesPath` for each channel as `<channelName>ModulesPath`. And you can use
`disabledModules` to remove modules from the current channel.

Pulling the zsh module from the latest flake:
```nix
{ latestModulesPath }: {
  modules = [ "${latestModulesPath}/programs/zsh/zsh.nix" ];
  disabledModules = [ "programs/zsh/zsh.nix" ];
}
```

> ##### _Note:_
> Sometimes a modules name will change from one branch to another.

[nixpkgs-modules]: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules

# Overrides
Each NixOS host follows one channel. But many times it is useful to get packages
or modules from different channels.

## Packages
You can make use of `overlays/overrides.nix` to override specific packages in the
default channel to be pulled from other channels. That file is simply an example
of how any overlay can get `channels` as their first argument.

You can add overlays to any channel to override packages from other channels.

Pulling the manix package from the `latest` channel:
```nix
channels: final: prev: {
  __dontExport = true;
  inherit (pkgs.latest) manix;
}
```

It is recommended to set the `__dontExport` property for override specific
overlays. `overlays/overrides.nix` is the best place to consolidate all package
overrides and the property is already set for you.

## Modules

You can also pull modules from other channels. All modules have access to the 
`modulesPath` for each channel as `<channelName>ModulesPath`. And you can use
`disabledModules` to remove modules from the current channel.

Pulling the zsh module from the `latest` channel:
```nix
{ latestModulesPath }: {
  modules = [ "${latestModulesPath}/programs/zsh/zsh.nix" ];
  disabledModules = [ "programs/zsh/zsh.nix" ];
}
```

> ##### _Note:_
> Sometimes a modules name will change from one branch to another.

[nixpkgs-modules]: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules

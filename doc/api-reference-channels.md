# Channels API Container
Configure your channels that you can use throughout your configurations.

> #### ⚠ Gotcha ⚠
> Devshell & (non-host-specific) Home-Manager `pkgs` instances are rendered off the
> `nixos.hostDefaults.channelName` (default) channel.


## channels
nixpkgs channels to create


*_Type_*:
attribute set of submodules or path convertible to it


*_Default_*
```
{}
```




## channels.\<name\>.config
nixpkgs config for this channel


*_Type_*:
attribute set or path convertible to it


*_Default_*
```
{}
```




## channels.\<name\>.input
nixpkgs flake input to use for this channel


*_Type_*:
nix flake


*_Default_*
```
"self.inputs.<name>"
```




## channels.\<name\>.overlays
overlays to apply to this channel
these will get exported under the 'overlays' flake output
as \<channel\>/\<name\> and any overlay pulled from \<inputs\>
will be filtered out


*_Type_*:
list of valid Nixpkgs overlay or path convertible to its or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## channels.\<name\>.patches
patches to apply to this channel


*_Type_*:
list of paths


*_Default_*
```
[]
```





# Channels API Container
Configure your channels that you can use throughout your configurations.

> #### ⚠ Gotcha ⚠
> Devshell & (non-host-specific) Home-Manager `pkgs` instances are rendered off the
> `nixos.hostDefaults.channelName` (default) channel.


## channels
Nixpkgs channels to create.


*_Type_*:
attribute set of submodules or path convertible to it


*_Default_*
```
{}
```




## channels.\<name\>.config
Nixpkgs config for this channel.


*_Type_*:
attribute set or path convertible to it


*_Default_*
```
{}
```




## channels.\<name\>.input
Nixpkgs flake input to use for this channel.


*_Type_*:
Valid flake


*_Default_*
```
"self.inputs.<name>"
```




## channels.\<name\>.overlays
Overlays to apply to this channel and export via the 'overlays' flake output.

The attributes in the 'overlays' output will be named following the
'\<channel\>/\<name\>' format.

Any overlay pulled from \<inputs\> will not be exported.


*_Type_*:
list of Valid channel overlay or path convertible to its or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## channels.\<name\>.patches
Patches to apply to this channel.


*_Type_*:
list of paths


*_Default_*
```
[]
```





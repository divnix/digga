## channels
nixpkgs channels to create

*_Type_*:
attribute set of submodules

*_Default_*
```
{"nixpkgs":{"input":"/nix/store/4dqrf3ly31g9ypgm89rn7b1p06vddll6-source"}}
```


## channels.<name>.config
nixpkgs config for this channel

*_Type_*:
path that evaluates to a(n) attrs

*_Default_*
```
{}
```


## channels.<name>.externalOverlays
overlays to apply to the channel that don't get exported to the flake output
useful to include overlays from inputs

*_Type_*:
path that evaluates to a(n) listOf

*_Default_*
```
[]
```


## channels.<name>.input
nixpkgs flake input to use for this channel

*_Type_*:
nix flake

*_Default_*
```
"/nix/store/4dqrf3ly31g9ypgm89rn7b1p06vddll6-source"
```


## channels.<name>.overlays
overlays to apply to this channel
these will get exported under the 'overlays' flake output as <channel>/<name>

*_Type_*:
path that evaluates to a(n) listOf

*_Default_*
```
[]
```


## home
hosts, modules, suites, and profiles for home-manager

*_Type_*:
submodule

*_Default_*
```
{}
```


## home.externalModules
list of modules to include in confguration but these are not exported to the '‹name›Modules' output

*_Type_*:
path that evaluates to a(n) listOf

*_Default_*
```
[]
```


## home.modules
list of modules to include in confgurations and export in '‹name›Modules' output

*_Type_*:
path that evaluates to a(n) listOf

*_Default_*
```
[]
```


## home.profiles
path to profiles folder that can be collected into suites
*_Type_*:
path

*_Default_*
```
"${self}/profiles"
```


## home.suites
Function with the input of 'profiles' that returns an attribute set
with the suites for this config system.
These can be accessed through the 'suites' special argument.

*_Type_*:
path that evaluates to a(n) functionTo

*_Default_*
```
"<function>"
```


## nixos
hosts, modules, suites, and profiles for nixos

*_Type_*:
submodule

*_Default_*
```
{}
```


## nixos.configDefaults
defaults for all configs

*_Type_*:
submodule

*_Default_*
```
{}
```


## nixos.configDefaults.channelName
Channel this config should follow

*_Type_*:
one of <set>

*_Default_*
```
"nixpkgs"
```


## nixos.configDefaults.externalmodules
The configuration for this config

*_Type_*:
path that evaluates to a(n) anything

*_Default_*
```
[]
```


## nixos.configDefaults.modules
The configuration for this config

*_Type_*:
path that evaluates to a(n) anything

*_Default_*
```
[]
```


## nixos.configDefaults.system
system for this config

*_Type_*:
one of "aarch64-linux", "i686-linux", "x86_64-darwin", "x86_64-linux"

*_Default_*
```
"x86_64-linux"
```


## nixos.configs
configurations to include in the ‹name›Configurations output

*_Type_*:
path that evaluates to a(n) attrsOf

*_Default_*
```
{}
```


## nixos.configs.<name>.channelName
Channel this config should follow

*_Type_*:
one of <set>

*_Default_*
```
"nixpkgs"
```


## nixos.configs.<name>.externalmodules
The configuration for this config

*_Type_*:
path that evaluates to a(n) anything

*_Default_*
```
[]
```


## nixos.configs.<name>.modules
The configuration for this config

*_Type_*:
path that evaluates to a(n) anything

*_Default_*
```
[]
```


## nixos.configs.<name>.system
system for this config

*_Type_*:
one of "aarch64-linux", "i686-linux", "x86_64-darwin", "x86_64-linux"

*_Default_*
```
"x86_64-linux"
```


## nixos.externalModules
list of modules to include in confguration but these are not exported to the '‹name›Modules' output

*_Type_*:
path that evaluates to a(n) listOf

*_Default_*
```
[]
```


## nixos.modules
list of modules to include in confgurations and export in '‹name›Modules' output

*_Type_*:
path that evaluates to a(n) listOf

*_Default_*
```
[]
```


## nixos.profiles
path to profiles folder that can be collected into suites
*_Type_*:
path

*_Default_*
```
"${self}/profiles"
```


## nixos.suites
Function with the input of 'profiles' that returns an attribute set
with the suites for this config system.
These can be accessed through the 'suites' special argument.

*_Type_*:
path that evaluates to a(n) functionTo

*_Default_*
```
"<function>"
```


## self
The flake to create the devos outputs for
*_Type_*:
nix flake



## supportedSystems
The systems supported by this flake

*_Type_*:
list of strings

*_Default_*
```
["aarch64-linux","i686-linux","x86_64-darwin","x86_64-linux"]
```



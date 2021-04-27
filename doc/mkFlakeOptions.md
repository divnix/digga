## channels
nixpkgs channels to create


*_Type_*:
attribute set of submodules


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
"inputs.<name>"
```




## channels.\<name\>.overlays
overlays to apply to this channel
these will get exported under the 'overlays' flake output
as \<channel\>/\<name\> and any overlay pulled from ${inputs}
will be filtered out


*_Type_*:
list of valid Nixpkgs overlay or path convertible to its or anything convertible to it


*_Default_*
```
[]
```




## channelsConfig
nixpkgs config for all channels


*_Type_*:
attribute set or path convertible to it


*_Default_*
```
{}
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
modules to include that won't be exported
meant importing modules from external flakes


*_Type_*:
list of valid module or path convertible to its


*_Default_*
```
[]
```




## home.modules
modules to include in all hosts and export to homeModules output


*_Type_*:
list of path to a modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## home.profiles
profile folders that can be collected into suites
the name of the argument passed to suites is based
on the folder name.
[ ./profiles ] => { profiles }:


*_Type_*:
list of paths


*_Default_*
```
[]
```




## home.suites
Function that takes profiles and returns suites for this config system
These can be accessed through the 'suites' special argument.


*_Type_*:
function that evaluates to a(n) attrs or path convertible to it


*_Default_*
```
"<function>"
```




## inputs
inputs for this flake
used to set channel defaults and create registry


*_Type_*:
attribute set of nix flakes






## nixos
hosts, modules, suites, and profiles for nixos


*_Type_*:
submodule


*_Default_*
```
{}
```




## nixos.hostDefaults
Defaults for all hosts.
the modules passed under hostDefaults will be exported
to the 'nixosModules' flake output.
They will also be added to all hosts.


*_Type_*:
submodule


*_Default_*
```
{}
```




## nixos.hostDefaults.channelName
Channel this host should follow


*_Type_*:
a channel defined in `channels`


*_Default_*
```
null
```




## nixos.hostDefaults.externalModules
modules to include that won't be exported
meant importing modules from external flakes


*_Type_*:
list of valid module or path convertible to its


*_Default_*
```
[]
```




## nixos.hostDefaults.modules
modules to include in all hosts and export to nixosModules output


*_Type_*:
list of path to a modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## nixos.hostDefaults.system
system for this host


*_Type_*:
system defined in `supportedSystems`


*_Default_*
```
null
```




## nixos.hosts
configurations to include in the nixosConfigurations output


*_Type_*:
attribute set of submodules


*_Default_*
```
{}
```




## nixos.hosts.\<name\>.channelName
Channel this host should follow


*_Type_*:
a channel defined in `channels`


*_Default_*
```
null
```




## nixos.hosts.\<name\>.modules
modules to include


*_Type_*:
list of valid module or path convertible to its or anything convertible to it


*_Default_*
```
[]
```




## nixos.hosts.\<name\>.system
system for this host


*_Type_*:
system defined in `supportedSystems`


*_Default_*
```
null
```




## nixos.profiles
profile folders that can be collected into suites
the name of the argument passed to suites is based
on the folder name.
[ ./profiles ] => { profiles }:


*_Type_*:
list of paths


*_Default_*
```
[]
```




## nixos.suites
Function that takes profiles and returns suites for this config system
These can be accessed through the 'suites' special argument.


*_Type_*:
function that evaluates to a(n) attrs or path convertible to it


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




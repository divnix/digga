## extern
Function with argument 'inputs' that contains all devos and ${self}'s inputs.
The function should return an attribute set with modules, overlays, and
specialArgs to be included across nixos and home manager configurations.
Only attributes that are used should be returned.


*_Type_*:
function that evaluates to a(n) attrs

*_Default_*
```
"{ modules = []; overlays = []; specialArgs = []; userModules = []; userSpecialArgs = []; }\n"
```


## hosts
Path to directory containing host configurations that will be exported
to the 'nixosConfigurations' output.


*_Type_*:
path

*_Default_*
```
"${self}/hosts"
```


## modules
list of modules to include in confgurations and export in 'nixosModules' output


*_Type_*:
list of valid modules

*_Default_*
```
[]
```


## overlays
path to folder containing overlays which will be applied to pkgs and exported in
the 'overlays' output


*_Type_*:
path

*_Default_*
```
"${self}/overlays"
```


## overrides
attrset of packages and modules that will be pulled from nixpkgs master

*_Type_*:
attribute set

*_Default_*
```
"{ modules = []; disabledModules = []; packages = {}; }"
```


## packages
Overlay for custom packages that will be included in treewide 'pkgs'.
This should follow the standard nixpkgs overlay format - two argument function
that returns an attrset.
These packages will be exported to the 'packages' and 'legacyPackages' outputs.


*_Type_*:
Nixpkgs overlay

*_Default_*
```
"(final: prev: {})"
```


## profiles
path to profiles folder that can be collected into suites

*_Type_*:
path

*_Default_*
```
"${self}/profiles"
```


## self
The flake to create the devos outputs for

*_Type_*:
attribute set



## suites
Function with inputs 'users' and 'profiles' that returns attribute set
with user and system suites. The former for Home Manager and the latter
for nixos configurations.
These can be accessed through the 'suites' specialArg in each config system.


*_Type_*:
function that evaluates to a(n) attrs

*_Default_*
```
"{ user = {}; system = {}; }"
```


## userModules
list of modules to include in home-manager configurations and export in
'homeModules' output


*_Type_*:
list of valid modules

*_Default_*
```
[]
```


## userProfiles
path to user profiles folder that can be collected into userSuites

*_Type_*:
path

*_Default_*
```
"${self}/users/profiles"
```


## users
path to folder containing profiles that define system users


*_Type_*:
path

*_Default_*
```
"${self}/users"
```



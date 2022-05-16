# Home-Manager API Container
Configure your home manager modules, profiles & suites.


## home
home-manager user configurations.


*_Type_*:
submodule or path convertible to it


*_Default_*
```
{}
```




## home.exportedModules
Modules to include and export to the homeModules flake output.


*_Type_*:
list of Valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## home.externalModules
The `externalModules` option has been removed.
Any modules that should be exported should be defined with the `exportedModules`
option and all other modules should just go into the `modules` option.


*_Type_*:
list of Valid modules or anything convertible to it


*_Default_*
```
[]
```




## home.importables
Packages of paths to be passed to modules as additional args.


*_Type_*:
attribute set


*_Default_*
```
{}
```




## home.importables.suites
Collections of profiles.


*_Type_*:
null or attribute set of list of paths or anything convertible to its or path convertible to it


*_Default_*
```
null
```




## home.modules
Default modules to import for all hosts.

These modules will not be exported via flake outputs.
Primarily useful for importing modules from external flakes.


*_Type_*:
list of Valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## home.users
home-manager users that can be deployed portably to any host.

These configurations must work on *all* supported systems.

Generic Linux systems only support these portable home-manager
configurations. They cannot be configured as hosts like NixOS or
nix-darwin systems.


*_Type_*:
attribute set of HM user configs


*_Default_*
```
{}
```





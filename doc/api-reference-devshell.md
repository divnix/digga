# Devshell API Container
Configure your devshell module collections of your environment.


## devshell
Modules to include in our development shell.


*_Type_*:
submodule or path convertible to it


*_Default_*
```
{}
```




## devshell.exportedModules
Modules to include and export to the devshellModules flake output.


*_Type_*:
list of Valid module or path convertible to its or anything convertible to it


*_Default_*
```
[]
```




## devshell.externalModules
The `externalModules` option has been removed.
Any modules that should be exported should be defined with the `exportedModules`
option and all other modules should just go into the `modules` option.


*_Type_*:
list of Valid modules or anything convertible to it


*_Default_*
```
[]
```




## devshell.modules
Default modules to import for all hosts.

These modules will not be exported via flake outputs.
Primarily useful for importing modules from external flakes.


*_Type_*:
list of Valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```





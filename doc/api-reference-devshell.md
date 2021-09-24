# Devshell API Container
Configure your devshell module collections of your environment.


## devshell
Modules to include in your DevOS shell. the `modules` argument
will be exported under the `devshellModules` output


*_Type_*:
submodule or path convertible to it


*_Default_*
```
{}
```




## devshell.exportedModules
modules to include in all hosts and export to devshellModules output


*_Type_*:
list of valid module or path convertible to its or anything convertible to it


*_Default_*
```
[]
```




## devshell.externalModules
ERROR: The `externalModules` option has been removed.
Any modules that should be exported should be defined with the `exportedModules`
option and all other modules should just go into the `modules` option.


*_Type_*:
list of valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## devshell.modules
modules to include that won't be exported
meant importing modules from external flakes


*_Type_*:
list of valid modules or anything convertible to it


*_Default_*
```
[]
```





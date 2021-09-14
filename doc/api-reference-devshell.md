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




## devshell.externalModules
modules to include that won't be exported
meant importing modules from external flakes


*_Type_*:
list of valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## devshell.modules
modules to include in all hosts and export to devshellModules output


*_Type_*:
list of valid module or path convertible to its or anything convertible to it


*_Default_*
```
[]
```





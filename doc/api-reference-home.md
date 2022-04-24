# Home-Manager API Container
Configure your home manager modules, profiles & suites.


## home
hosts, modules, suites, and profiles for home-manager


*_Type_*:
submodule or path convertible to it


*_Default_*
```
{}
```




## home.exportedModules
modules to include in all hosts and export to homeModules output


*_Type_*:
list of valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## home.externalModules
The `externalModules` option has been removed.
Any modules that should be exported should be defined with the `exportedModules`
option and all other modules should just go into the `modules` option.


*_Type_*:
list of valid modules or anything convertible to it


*_Default_*
```
[]
```




## home.importables
Packages of paths to be passed to modules as `specialArgs`.


*_Type_*:
attribute set


*_Default_*
```
{}
```




## home.importables.suites
collections of profiles


*_Type_*:
null or attribute set of list of paths or anything convertible to its or path convertible to it


*_Default_*
```
null
```




## home.modules
modules to include that won't be exported
meant importing modules from external flakes


*_Type_*:
list of valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## home.users
HM users that can be deployed portably without a host.


*_Type_*:
attribute set of HM user configs


*_Default_*
```
{}
```





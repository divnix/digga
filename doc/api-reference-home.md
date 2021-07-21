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




## home.externalModules
modules to include that won't be exported
meant importing modules from external flakes


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
modules to include in all hosts and export to homeModules output


*_Type_*:
list of valid modules or anything convertible to it


*_Default_*
```
[]
```




## home.profiles
WARNING: The 'suites' and `profiles` options have been deprecated, you can now create
both with the importables option. `rakeLeaves` can be used to create profiles and
by passing a module or `rec` set to `importables`, suites can access profiles.
Example:
```
importables = rec {
  profiles = digga.lib.rakeLeaves ./profiles;
  suites = with profiles; { };
}
```
See https://github.com/divnix/digga/pull/30 for more details


*_Type_*:
list of paths or path convertible to it


*_Default_*
```
[]
```




## home.suites
WARNING: The 'suites' and `profiles` options have been deprecated, you can now create
both with the importables option. `rakeLeaves` can be used to create profiles and
by passing a module or `rec` set to `importables`, suites can access profiles.
Example:
```
importables = rec {
  profiles = digga.lib.rakeLeaves ./profiles;
  suites = with profiles; { };
}
```
See https://github.com/divnix/digga/pull/30 for more details


*_Type_*:
function that evaluates to a(n) attrs or path convertible to it






## home.users
HM users that can be deployed portably without a host.


*_Type_*:
attribute set of hm user configs


*_Default_*
```
{}
```





# Home-Manager API Container

Configure your home manager modules, profiles & suites.

## home

hosts, modules, suites, and profiles for home-manager

_*Type*_:
submodule or path convertible to it

_*Default*_

```
{}
```

## home.exportedModules

modules to include in all hosts and export to homeModules output

_*Type*_:
list of valid modules or anything convertible to it or path convertible to it

_*Default*_

```
[]
```

## home.externalModules

The `externalModules` option has been removed.
Any modules that should be exported should be defined with the `exportedModules`
option and all other modules should just go into the `modules` option.

_*Type*_:
list of valid modules or anything convertible to it

_*Default*_

```
[]
```

## home.importables

Packages of paths to be passed to modules as `specialArgs`.

_*Type*_:
attribute set

_*Default*_

```
{}
```

## home.importables.suites

collections of profiles

_*Type*_:
null or attribute set of list of paths or anything convertible to its or path convertible to it

_*Default*_

```
null
```

## home.modules

modules to include that won't be exported
meant importing modules from external flakes

_*Type*_:
list of valid modules or anything convertible to it or path convertible to it

_*Default*_

```
[]
```

## home.users

HM users that can be deployed portably without a host.

_*Type*_:
attribute set of HM user configs

_*Default*_

```
{}
```

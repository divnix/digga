# NixOS API Container

Configure your nixos modules, profiles & suites.

## nixos

hosts, modules, suites, and profiles for NixOS

_*Type*_:
submodule or path convertible to it

_*Default*_

```
{}
```

## nixos.hostDefaults

Defaults for all hosts.
the modules passed under hostDefaults will be exported
to the 'nixosModules' flake output.
They will also be added to all hosts.

_*Type*_:
submodule

_*Default*_

```
{}
```

## nixos.hostDefaults.channelName

Channel this host should follow

_*Type*_:
channel defined in `channels`

## nixos.hostDefaults.exportedModules

modules to include in all hosts and export to nixosModules output

_*Type*_:
list of valid modules or anything convertible to it or path convertible to it

_*Default*_

```
[]
```

## nixos.hostDefaults.externalModules

The `externalModules` option has been removed.
Any modules that should be exported should be defined with the `exportedModules`
option and all other modules should just go into the `modules` option.

_*Type*_:
list of valid modules or anything convertible to it

_*Default*_

```
[]
```

## nixos.hostDefaults.modules

modules to include that won't be exported
meant importing modules from external flakes

_*Type*_:
list of valid modules or anything convertible to it or path convertible to it

_*Default*_

```
[]
```

## nixos.hostDefaults.system

system for this host

_*Type*_:
null or system defined in `supportedSystems`

_*Default*_

```
null
```

## nixos.hosts

configurations to include in the nixosConfigurations output

_*Type*_:
attribute set of submodules

_*Default*_

```
{}
```

## nixos.hosts.\<name\>.channelName

Channel this host should follow

_*Type*_:
null or channel defined in `channels`

_*Default*_

```
null
```

## nixos.hosts.\<name\>.modules

modules to include

_*Type*_:
list of valid modules or anything convertible to it or path convertible to it

_*Default*_

```
[]
```

## nixos.hosts.\<name\>.system

system for this host

_*Type*_:
null or system defined in `supportedSystems`

_*Default*_

```
null
```

## nixos.hosts.\<name\>.tests

tests to run

_*Type*_:
list of valid NixOS test or path convertible to its or anything convertible to it

_*Default*_

```
[]
```

_*Example*_

```
{"_type":"literalExpression","text":"[\n  {\n    name = \"testname1\";\n    machine = { ... };\n    testScript = ''\n      # ...\n    '';\n  }\n  ({ corutils, writers, ... }: {\n    name = \"testname2\";\n    machine = { ... };\n    testScript = ''\n      # ...\n    '';\n  })\n  ./path/to/test.nix\n];\n"}
```

## nixos.importables

Packages of paths to be passed to modules as `specialArgs`.

_*Type*_:
attribute set

_*Default*_

```
{}
```

## nixos.importables.suites

collections of profiles

_*Type*_:
null or attribute set of list of paths or anything convertible to its or path convertible to it

_*Default*_

```
null
```

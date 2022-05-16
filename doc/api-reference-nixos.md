# NixOS API Container
Configure your nixos modules, profiles & suites.


## nixos
NixOS host configurations.


*_Type_*:
submodule or path convertible to it


*_Default_*
```
{}
```




## nixos.hostDefaults
Defaults for all hosts.


*_Type_*:
submodule


*_Default_*
```
{}
```




## nixos.hostDefaults.channelName
Channel this host should follow.


*_Type_*:
One of the channels defined in `channels`






## nixos.hostDefaults.exportedModules
Modules to include and export to the nixosModules flake output.


*_Type_*:
list of Valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## nixos.hostDefaults.externalModules
The `externalModules` option has been removed.
Any modules that should be exported should be defined with the `exportedModules`
option and all other modules should just go into the `modules` option.


*_Type_*:
list of Valid modules or anything convertible to it


*_Default_*
```
[]
```




## nixos.hostDefaults.modules
Default modules to import for all hosts.

These modules will not be exported via flake outputs.
Primarily useful for importing modules from external flakes.


*_Type_*:
list of Valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## nixos.hostDefaults.system
System for this host.


*_Type_*:
null or One of the systems defined in `supportedSystems`


*_Default_*
```
null
```




## nixos.hosts
Configurations to export via the nixosConfigurations flake output.


*_Type_*:
attribute set of submodules


*_Default_*
```
{}
```




## nixos.hosts.\<name\>.channelName
Channel this host should follow.


*_Type_*:
null or One of the channels defined in `channels`


*_Default_*
```
null
```




## nixos.hosts.\<name\>.modules
Modules to include for this specific host only.


*_Type_*:
list of Valid modules or anything convertible to it or path convertible to it


*_Default_*
```
[]
```




## nixos.hosts.\<name\>.system
System for this host.


*_Type_*:
null or One of the systems defined in `supportedSystems`


*_Default_*
```
null
```




## nixos.hosts.\<name\>.tests
Tests to run for this host.


*_Type_*:
list of Valid NixOS test or path convertible to its or anything convertible to it


*_Default_*
```
[]
```


*_Example_*
```
{"_type":"literalExpression","text":"[\n  {\n    name = \"testname1\";\n    machine = { ... };\n    testScript = ''\n      # ...\n    '';\n  }\n  ({ corutils, writers, ... }: {\n    name = \"testname2\";\n    machine = { ... };\n    testScript = ''\n      # ...\n    '';\n  })\n  ./path/to/test.nix\n];\n"}
```


## nixos.importables
Packages of paths to be passed to modules as additional args.


*_Type_*:
attribute set


*_Default_*
```
{}
```




## nixos.importables.suites
Collections of profiles.


*_Type_*:
null or attribute set of list of paths or anything convertible to its or path convertible to it


*_Default_*
```
null
```





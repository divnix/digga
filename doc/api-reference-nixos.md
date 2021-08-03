# NixOS API Container
Configure your nixos modules, profiles & suites.


## nixos
hosts, modules, suites, and profiles for nixos


*_Type_*:
submodule or path convertible to it


*_Default_*
```
{}
```




## nixos.hostDefaults
Defaults for all hosts.
the modules passed under hostDefaults will be exported
to the 'nixosModules' flake output.
They will also be added to all hosts.


*_Type_*:
submodule


*_Default_*
```
{}
```




## nixos.hostDefaults.channelName
Channel this host should follow


*_Type_*:
channel defined in `channels`






## nixos.hostDefaults.externalModules
modules to include that won't be exported
meant importing modules from external flakes


*_Type_*:
list of valid modules or anything convertible to it


*_Default_*
```
[]
```




## nixos.hostDefaults.modules
modules to include in all hosts and export to nixosModules output


*_Type_*:
list of valid modules or anything convertible to it


*_Default_*
```
[]
```




## nixos.hostDefaults.system
system for this host


*_Type_*:
null or system defined in `supportedSystems`


*_Default_*
```
null
```




## nixos.hosts
configurations to include in the nixosConfigurations output


*_Type_*:
attribute set of submodules


*_Default_*
```
{}
```




## nixos.hosts.\<name\>.channelName
Channel this host should follow


*_Type_*:
null or channel defined in `channels`


*_Default_*
```
null
```




## nixos.hosts.\<name\>.modules
modules to include


*_Type_*:
list of valid modules or anything convertible to it


*_Default_*
```
[]
```




## nixos.hosts.\<name\>.system
system for this host


*_Type_*:
null or system defined in `supportedSystems`


*_Default_*
```
null
```




## nixos.hosts.\<name\>.tests
tests to run


*_Type_*:
list of valid nixos test or path convertible to its or anything convertible to it


*_Default_*
```
[]
```


*_Example_*
```
{"_type":"literalExample","text":"[\n  {\n    name = \"testname1\";\n    machine = { ... };\n    testScript = ''\n      # ...\n    '';\n  }\n  ({ corutils, writers, ... }: {\n    name = \"testname2\";\n    machine = { ... };\n    testScript = ''\n      # ...\n    '';\n  })\n  ./path/to/test.nix\n];\n"}
```


## nixos.importables
Packages of paths to be passed to modules as `specialArgs`.


*_Type_*:
attribute set


*_Default_*
```
{}
```




## nixos.importables.suites
collections of profiles


*_Type_*:
null or attribute set of list of paths or anything convertible to its or path convertible to it


*_Default_*
```
null
```




## nixos.profiles
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




## nixos.suites
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







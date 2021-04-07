# DevOS 2.0

- We want to be a god ecosystem citizen, therefore we want to rebase on [`gytis/flake-utils-plus`](https://github.com/gytis-ivaskevicius/flake-utils-plus).
- `gytis/flake-utils-plus` is designed to be incorporated in upstream flake-utils. As the name suggests, it wraps and extends `flake-utils` for nixos related use cases.
- `devos-lib` shall be another layer that wraps `flakes-utils-plus` and adds accoustomed devos amentities, such as:
  - automagic importers, for pure convenience, but without prescribing a particular folder layout (that is something for devos templates to achieve).
  - additional configuration generators, such as for `deploy-rs` or `home-manager` or other future integrations (eg. mobile nixos, etc) that we want to offer as a convenience.
  - other amentities (tbd)



## Importers

Importers declutter the top level flake. The goal is to have a bunch of lines that read like a very clean table of contents:

```nix
  concept1 = ./concept1;
  concept2 = ./concept2;
  concept3 = { "..." = "..."; };
  concept4 = [];
```
It seems important to enable dual use (importing files or declaring inline), in order to allow people to generate user 
flakes that put emphasis on different aspects of using devos lib (by sheer looking on the folder hierarchy).

Some context about importers, and how we might want them to behave:

 - https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/8
 - https://github.com/blaggacao/devos/blob/5d80663bcd3f65cc95fd965b49becc7b24ebf9d4/lib/devos/importer.nix


## Config Generators

Configuration Generators generate configurations for particular entities. In practice and for now,

- a [nixosConfigurationsGenerator](https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/51cb739c9c9c2258bc70747eb7bc22975ae244bd/systemFlake.nix#L61-L64) creates nixosConfigurations,
- based on which a [deployConfigurationsGenerator](https://github.com/blaggacao/devos/blob/5d80663bcd3f65cc95fd965b49becc7b24ebf9d4/lib/devos/configGenerators.nix#L14-L25) generates deploy-rs configurations &
- a [hmConfigurationsGenerator](https://github.com/blaggacao/devos/blob/5d80663bcd3f65cc95fd965b49becc7b24ebf9d4/lib/devos/configGenerators.nix#L34-L45) generates home manager configurations.

See also: https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/10


## API

The devos-lib onion:

- `builtins`
- `numtide/flake-utils`
- `gytis/flake-utils-plus`
- `divnix/devos` (the lib)

While flake-utils-plus exports a generic [`utils.systemFlake`](https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/51cb739c9c9c2258bc70747eb7bc22975ae244bd/flake.nix#L37) user function 
and is restricted from including dependencies, devos-lib should export a `devos.systemFlake` kwithout such restrictions and that can include
additional (eventually third-party mediated) generatros, such as `deploy-rs`, while implementing a strict superset of
`utils.systemFlake` api and, on the other hand, a `devos.mkFlake` with importer amenities included and a slightly different api for convenience.

Such function would have the following top level API

```nix
# devos.systemFlake
{
# adopt flake-utils-plus, file upstream issues where discussion is needed
  self
, defaultSystem ? "x86_64-linux"
, supportedSystems ? flake-utils.lib.defaultSystems
, name # or inputs, see: https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/12
, nixosConfigurations ? { } # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/14
, nixosHosts ? { NAME = { # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/16
    system = "...";
    channelName = "...";
    extraArgs = { };
    modules = [ ];
  };}
, channels ? {
    input = "...";
    overlaysBuilder = channels: [ (final: prev: { })];
    config = { };
    patches = [ ];
  }
, channelsConfig ? { }
, sharedModules ? [ ] 
, sharedOverlays ? [ ]
, nixosSpecialArgs ? { } # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/13#issuecomment-814512835

, hmConfigurations ? { }
, hmProfiles ? { NAME = { 
    modules = [ ];
    extraArgs = { };
    # what else makes sense, here?
  };}
  
, deployConfigurations ? { }

, ... # passed through
}
```

```nix
# devos.mkFlake'
{
  self
, defaultSystem ? "x86_64-linux"
, supportedSystems ? flake-utils.lib.defaultSystems
, name # or inputs, see: https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/12
, nixosConfigurations ? { }  # escape hatch / https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/14
, hmConfigurations ? { }     # escape hatch / https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/14
, deployConfigurations ? { } # escape hatch / https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/14
, channels ? {
    input = "...";
    overlaysBuilder = channels: [ (final: prev: { })];
    config = { };
    patches = [ ];
  }
, channelsConfig ? { }
, sharedModules ? [ ] 
, sharedOverlays ? [ ]

, nixosModules ? [ ]
, nixosProfiles ? [ ]
, nixosUserProfiles ? [ ]
, nixosSpecialArgs ? { } # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/13#issuecomment-814512835
, nixosHosts ? { NAME = {    # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/16
    system = "...";
    channelName = "...";
    extraArgs = { };
    modules = [ ];
  };}
, nixosSuites = { };
, hmModules ? [ ]
, hmProfiles ? [ ]
, hmSpecialArgs ? { }
, hmSuites = { };
, ... # passed through
}
```

```nix
# devos.mkFlake
{
  self
, defaultSystem ? "x86_64-linux"
, supportedSystems ? flake-utils.lib.defaultSystems
, name # or inputs, see: https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/12
, nixosConfigurations ? { }  # escape hatch / https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/14
, hmConfigurations ? { }     # escape hatch / https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/14
, deployConfigurations ? { } # escape hatch / https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/14
, channels ? {
    input = "...";
    overlaysBuilder = channels: [ (final: prev: { })]; # TODO: do we want another interface here? Also: how to handle module backports?
    config = { };
    patches = [ ];
  }
, channelsConfig ? { }
, sharedModules ? [ ] 
, sharedOverlays ? [ ]

, nixosModules ? ./modules
, nixosProfiles ? ./profiles
, nixosUserProfiles ? ./users
, nixosSpecialArgs ? { } # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/13#issuecomment-814512835
, nixosHosts ? ./hosts
, nixosSuites = ./suites;
, hmModules ? ./users/modules
, hmProfiles ? ./users/profiles
, hmSuites = ./users/suites;
, hmSpecialArgs ? { }
, ... # passed through
}
```

# Top Level API

`digga`'s top level API. API Containers are documented in their respective sub-chapter:

- [Channels](./api-reference-channels.md)
- [Home](./api-reference-home.md)
- [Devshell](./api-reference-devshell.md)
- [NixOS](./api-reference-nixos.md)
- [Darwin](./api-reference-darwin.md)

## channelsConfig

nixpkgs config for all channels

_*Type*_:
attribute set or path convertible to it

_*Default*_

```
{}
```

## inputs

The flake's inputs

_*Type*_:
attribute set of nix flakes

## outputsBuilder

builder for flake system-spaced outputs
The builder gets passed an attrset of all channels

_*Type*_:
function that evaluates to a(n) attribute set or path convertible to it

_*Default*_

```
"channels: { }"
```

## self

The flake to create the DevOS outputs for

_*Type*_:
nix flake

## supportedSystems

The systems supported by this flake

_*Type*_:
list of strings

_*Default*_

```
["aarch64-linux","aarch64-darwin","x86_64-darwin","x86_64-linux"]
```

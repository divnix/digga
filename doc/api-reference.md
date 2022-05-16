# Top Level API
`digga`'s top level API. API Containers are documented in their respective sub-chapter:

- [Channels](./api-reference-channels.md)
- [Home](./api-reference-home.md)
- [Devshell](./api-reference-devshell.md)
- [NixOS](./api-reference-nixos.md)
- [Darwin](./api-reference-darwin.md)

## channelsConfig
Nixpkgs configuration shared between all channels.


*_Type_*:
attribute set or path convertible to it


*_Default_*
```
{}
```




## inputs
The flake's inputs.

*_Type_*:
attribute set of Valid flakes






## outputsBuilder
Builder for flake system-spaced outputs.


*_Type_*:
function that evaluates to a(n) attribute set or path convertible to it


*_Default_*
```
"channels: { }"
```




## self
The flake itself.

*_Type_*:
Valid flake






## supportedSystems
The systems supported by this flake.


*_Type_*:
list of strings


*_Default_*
```
["aarch64-linux","aarch64-darwin","i686-linux","x86_64-darwin","x86_64-linux"]
```





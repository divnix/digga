# Profiles

Profiles are a convenient shorthand for the [_definition_][definition] of
[options][options] in contrast to their [_declaration_][declaration]. They're
built into the NixOS module system for a reason: to elegantly provide a clear
separation of concerns.

## Creation
Profiles are created with the `rakeLeaves` function which recursively collects
`.nix` files from within a folder. The recursion stops at folders with a `default.nix` 
in them. You end up with an attribute set with leaves(paths to profiles) or
nodes(attrsets leading to more nodes or leaves).

A profile is used for quick modularization of [interelated bits](./profiles.md#subprofiles).

> ##### _Notes:_
> * For _declaring_ module options, there's the [modules](../outputs/modules.md) directory.
> * This directory takes inspiration from
>   [upstream](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/profiles)
>   .

### Nested profiles
Profiles can be nested in attribute sets due to the recursive nature of `rakeLeaves`.
This can be useful to have a set of profiles created for a specific purpose. It is
sometimes useful to have a `common` profile that has high level concerns related
to all its sister profiles.

### Example

profiles/develop/common.nix:
```nix
{
  imports = [ ./zsh ];
  # some generic development concerns ...
}
```

profiles/develop/zsh.nix:
```nix
{  ... }:
{
  programs.zsh.enable = true;
  # zsh specific options ...
}
```

The examples above will end up with a profiles set like this:
```nix
{
  develop = {
    common = ./profiles/develop/common.nix;
    zsh = ./profiles/develop/zsh.nix;
  };
}
```

## Conclusion
Profiles are the most important concept in DevOS. They allow us to keep our
Nix expressions self contained and modular. This way we can maximize reuse
across hosts while minimizing boilerplate. Remember, anything machine
specific belongs in your [host](hosts.md) files instead.

[definition]: https://nixos.org/manual/nixos/stable/index.html#sec-option-definitions
[declaration]: https://nixos.org/manual/nixos/stable/index.html#sec-option-declarations
[options]: https://nixos.org/manual/nixos/stable/index.html#sec-writing-modules
[spec]: https://github.com/divnix/devos/tree/core/lib/devos/mkProfileAttrs.nix
[config]: https://nixos.wiki/wiki/Module#structure

# Profiles

Profiles are a convenient shorthand for the [_definition_][definition] of
[options][options] in contrast to their [_declaration_][declaration]. They're
built into the NixOS module system for a reason: to elegantly provide a clear
separation of concerns.

If you need guidance, a community [branch](https://github.com/divnix/devos/tree/community/profiles)
is maintained to help get up to speed on their usage.

## Constraints
For the sake of consistency, a profile should always be defined in a
___default.nix___ containing a [nixos module config][config].
A profile's directory is used for quick modularization of
[interelated bits](./profiles.md#subprofiles).

> ##### _Notes:_
> * For _declaring_ module options, there's the [modules](../outputs/modules.md) directory.
> * This directory takes inspiration from
>   [upstream](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/profiles)
>   .
> * Sticking to a simple [spec][spec] has refreshing advantages.
>   [hercules-ci](../integrations/hercules.md) expects all profiles to be
>   defined in a ___default.nix___, allowing them to be built automatically when
>   added. Congruently, [suites](suites.md) expect ___default.nix___ to avoid
>   having to manage their paths manually.

## Subprofiles
Profiles can also define subprofiles. They follow the same constraints outlined
above. A good top level profile should be a high level concern, such as your
personal development environment while the subprofiles should be more focused
program configurations such as your text editor, and shell configs. This way,
you can either pull in the whole development profile, or pick and choose
individual programs.

### Example

profiles/develop/default.nix:
```nix
{
  imports = [ ./zsh ];
  # some generic development concerns ...
}
```

profiles/develop/zsh/default.nix:
```nix
{  ... }:
{
  programs.zsh.enable = true;
  # zsh specific options ...
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

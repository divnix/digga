# Profiles
Profiles are simply NixOS modules which contain generic expressions suitable
for any host. A good example is the configuration for a text editor, or
window manager. If you need some concrete examples, just checkout the
community [branch](https://github.com/divnix/devos/tree/community/profiles).

## Constraints
For the sake of consistency, a profile should always be defined in a
_default.nix_ containing a valid [nixos module](https://nixos.wiki/wiki/Module)
which ___does not___ declare any new
[module options](https://nixos.org/manual/nixos/stable/index.html#sec-option-declarations).
If you need to do that, use the [modules directory](../modules).

> ##### _Note:_
> [hercules-ci](../doc/integrations/hercules.md) expects all profiles to be
> defined in a _default.nix_. Similarly, [suites](../suites) expect a
> _default.nix_ as well.

### Example
#### Correct ✔
profiles/develop/default.nix:
```nix
{  ... }:
{
  programs.zsh.enable = true;
}
```

#### Incorrect ❌
profiles/develop.nix:
```nix
{
  options = {};
}
```

## Subprofiles
Profiles can also define subprofiles. They follow the same constraints outlined
above. A good top level profile should be a high level concern, such a your
personal development environment, and the subprofiles should be more concrete
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
Profiles are the most important concept in devos. They allow us to keep our
nix expressions self contained and modular. This way we can maximize reuse
while minimizing boilerplate. Always strive to keep your profiles as generic
and modular as possible. Anything machine specific belongs in your
[host](../hosts) files.

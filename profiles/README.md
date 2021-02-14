# Profiles
Profiles are simply NixOS modules which contain generic expressions suitable
for any host. A good example is the configuration for a text editor, or
window manager. If you need some concrete examples, just checkout the
community [branch](https://github.com/nrdxp/nixflk/tree/community/profiles).

## Constraints
For the sake of consistency, there are a few minor constraints. First of all, a
profile should always be defined in a `default.nix`, and it should always be a
a function taking a single attribute set as an argument, and returning a NixOS
module which does not define any new module options. If you need to make new
module option declarations, just use [modules](../modules).

These restrictions help simplify the import logic used to pass profles to
[suites](../suites).

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

## Conclusion
Profiles are the most important concept in nixflk. They allow us to keep our
nix expressions self contained and modular. This way we can maximize reuse
while minimizing boilerplate. Always strive to keep your profiles as generic
and modular as possible. Anything machine specific belongs in your
[host](../hosts) files.

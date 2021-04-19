# External Art
When you need to use a module, overlay, or pass a value from one of your inputs
to the rest of your NixOS configuration, [extern][extern] is where you do it.

Modules and overlays are self explanatory, and the `specialArgs` attribute is
used to extend the arguments passed to all NixOS modules, allowing for
arbitrary values to be passed from flake inputs to the rest of your
configuration.

## Home Manager
There is also an `hmModules` attribute set for pulling home-manager modules in
from the outside world:

### Declare:
flake.nix:
```nix
{
  inputs.doom-emacs.url = "github:vlaci/nix-doom-emacs";
}
```

extern/default.nix:
```nix
with inputs;
{
  hmModules = {
    doom-emacs = doom-emacs.hmModule;
  };
}
```

### Use:
users/nixos/default.nix:
```nix
{ hmModules, ... }:
{
  home-manager.users.nixos = {
    imports = [ hmModules.doom-emacs ] ;

    programs.doom-emacs.enable = true;
  };
}
```

[extern]: https://github.com/divnix/devos/tree/core/extern/default.nix

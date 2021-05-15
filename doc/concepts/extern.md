# External Art
When you need to use a module, overlay, or pass a value from one of your inputs
to the rest of your NixOS configuration, you can make use of a couple arguments.
It is encouraged to add external art directly in your `flake.nix` so the file
represents a complete dependency overview of your flake.

## Overlays
External overlays can directly be added to a channel's `overlays` list.

flake.nix:
```nix
{
  channels.nixos.overlays = [ inputs.agenix.overlay ];
}
```
Upon exporting overlays, these overlays will be automatically filtered out by inspecting the `inputs` argument.

## Modules
There is a dedicated `nixos.hostDefaults.externalModules` argument for external
modules.

flake.nix:
```nix
{
  nixos.hostDefaults.externalModules = [ inputs.agenix.nixosModules.age ];
}
```

## Home Manager
Since there isn't a `hosts` concept for home-manager, externalModules is just a
top-level argument in the `home` namespace.

flake.nix:
```nix
{
  home.externalModules = [ doom-emacs = doom-emacs.hmModule ];
}
```

> ##### Note:
> To avoid declaring "external" modules separately, which is obvious since they come from `inputs`, the optimal solution would be to automatically export modules that were created in
> your flake. But this is not possible due to NixOS/nix#4740.

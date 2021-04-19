# Modules
The modules directory is a replica of nixpkg's NixOS [modules][nixpkgs-modules]
, and follows the same semantics. This allows for trivial upstreaming into
nixpkgs proper once your module is sufficiently stable.

All modules linked in _module-list.nix_ are automatically exported via
`nixosModules.<file-basename>`, and imported into all [hosts](../concepts/hosts.md).


> ##### _Note:_
> This is reserved for declaring brand new module options. If you just want to
> declare a coherent configuration of already existing and related NixOS options
> , use [profiles](../concepts/profiles.md) instead.

## Semantics
In case you've never written a module for nixpkgs before, here is a brief
outline of the process.

### Declaration
modules/services/service-category/my-service.nix:
```nix
{ config, lib, ... }:
let
  cfg = config.services.myService;
in
{
  options.services.myService = {
    enable = lib.mkEnableOption "Description of my new service.";

    # additional options ...
  };

  config = lib.mkIf cfg.enable {
    # implementation ...
  };
}
```

### Import
modules/module-list.nix:
```nix
[
  ./services/service-category/my-service.nix
]
```

## Usage

### Internal
profiles/profile-category/my-profile.nix:
```nix
{ ... }:
{
  services.MyService.enable = true;
}
```

### External
flake.nix:
```nix
{
  # inputs omitted

  outputs = { self, devos, nixpkgs, ... }: {
    nixosConfigurations.myConfig = nixpkgs.lib.nixosSystem {
      system = "...";

      modules = [
        devos.nixosModules.my-service
        ({ ... }: {
          services.MyService.enable = true;
        })
      ];
    };
  };
}
```

[nixpkgs-modules]: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules

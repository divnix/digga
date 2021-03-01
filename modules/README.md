# Modules
The modules directory is a replica of nixpkg's NixOS [modules][nixpkgs-modules]
, and follows the same semantics. This allows for trivial upstreaming into
nixpkgs proper once your module is sufficiently stable.

All modules linked in _module-list.nix_ are automatically exported via
`nixosModules.<file-basename>`, and imported into all [hosts](../hosts).


> ##### _Note:_
> This is reserved for declaring brand new module options. If you just want to
> declare a coherent configuration of already existing and related NixOS options
> , use [profiles](../profiles) instead.

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

## Extend Modules

This folder also is a good place to extend modules beyond what nixpkgs provides, such
as for example to amend them with [RFC42][RFC42]:

modules/services/cluster/k3s/extended.nix
```nix
{ pkgs, config, lib, ... }:

let

  cfg = config.services.k3s;
  settingsFormat = pkgs.formats.yaml {};

in
{

  ##### interface

  cfg.settings = lib.mkOption {
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = ''
        Configuration for k3s server & agent, see
        <link xlink:href="https://rancher.com/docs/k3s/latest/en/installation/install-options/#configuration-file"/>,
        <link xlink:href="https://rancher.com/docs/k3s/latest/en/installation/install-options/server-config/"/>&
        <link xlink:href="https://rancher.com/docs/k3s/latest/en/installation/install-options/agent-config/"/>
        for supported values.
      '';
    };
  };

  ##### implementation

  config = lib.mkIf cfg.enable {
    # /etc/rancher/k3s/config.yaml
    environment.etc."rancher/k3s".source = format.generate "config.yaml" cfg.settings;
  };

}
```

[nixpkgs-modules]: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules
[RFC42]: https://github.com/NixOS/rfcs/pull/42

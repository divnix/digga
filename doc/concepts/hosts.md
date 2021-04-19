# Hosts

Nix flakes contain an output called `nixosConfigurations` declaring an
attribute set of valid NixOS systems. To simplify the management and creation
of these hosts, devos automatically imports every _.nix_ file inside this
directory to the mentioned attribute set, applying the projects defaults to
each. The only hard requirement is that the file contain a valid NixOS module.

As an example, a file `hosts/system.nix` will be available via the flake
output `nixosConfigurations.system`. You can have as many hosts as you want
and all of them will be automatically imported based on their name.

For each host, the configuration automatically sets the `networking.hostName`
attribute to the name of the file minus the _.nix_ extension. This is for
convenience, since `nixos-rebuild` automatically searches for a configuration
matching the current systems hostname if one is not specified explicitly.

It is recommended that the host modules only contain configuration information
specific to a particular piece of hardware. Anything reusable across machines
is best saved for [profile modules](./profiles.md).

This is a good place to import sets of profiles, called [suites](./suites.md),
that you intend to use on your machine.

Additionally, this is the perfect place to import anything you might need from
the [nixos-hardware][nixos-hardware] repository.

> ##### _Note:_
> Set `nixpkgs.system` to the architecture of this host, default is "x86_64-linux".
> Keep in mind that not all packages are available for all architectures.

## Example

hosts/librem.nix:
```nix
{ suites, hardware, ... }:
{
  imports = suites.laptop ++ [ hardware.purism-librem-13v3 ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}
```

[nixos-hardware]: https://github.com/NixOS/nixos-hardware

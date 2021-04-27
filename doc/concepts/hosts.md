# Hosts

Nix flakes contain an output called `nixosConfigurations` declaring an
attribute set of valid NixOS systems. To create hosts, you can use the 
`nixos.hosts` argument and pass `modules` to each host. Host-specific modules
typically go in the `hosts` folder of the template.

Each host should follow a certain channel to define the `pkgs` of that host.
You can use the `nixos.hostDefaults` to set defaults and global modules for all
hosts.

For each host, the configuration automatically sets the `networking.hostName`
attribute to the name of the host. This is for convenience, since `nixos-rebuild`
automatically searches for a configuration matching the current systems hostname
if one is not specified explicitly.

It is recommended that the host modules only contain configuration information
specific to a particular piece of hardware. Anything reusable across machines
is best saved for [profile modules](./profiles.md).

This is a good place to import sets of profiles, called [suites](./suites.md),
that you intend to use on your machine.

Additionally, you can pass modules from [nixos-hardware][nixos-hardware] in the
`modules` argument for relevant hosts.

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

flake.nix
```nix
{
  nixos.hosts.librem = {
    system = "aarch64-linux";
    modules = ./hosts/librem.nix;
  };
}
```


[nixos-hardware]: https://github.com/NixOS/nixos-hardware

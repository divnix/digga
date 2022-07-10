# Installation Media

This project leverages [nix-community/nixos-generators][nixos-generators] for
building machine images. In most cases, you'll probably want to use the
`install-iso` format.

Making an installable ISO for `hosts/bootstrap.nix` is as simple as:

```sh
nix run github:nix-community/nixos-generators -- \
  --format install-iso \
  --flake '.#bootstrap'
```

Then "burn" the ISO to your USB stick (or CD-R if you like!) following the
[instructions in the NixOS manual][burn] (or using your preferred USB burner).

You can also swap out the `--format` for [any of the others][formats] supported
by nixos-generators.

Continue by following the usual installation instructions in the NixOS manual.

## ISO Nix Store and Cache

The ISO image holds the Nix store for the live environment and _also_ acts as a
binary cache to the installer. To considerably speed things up, the image
already includes all flake `inputs` as well as the `devshell` closures.

While you _could_ provision any NixOS machine with the same USB stick, an ISO
custom-made for your target host will maximise those local cache hits. For hosts
that don't differ too much, a single USB stick might be ok, whereas when there
are bigger differences, a custom-made USB stick will be considerably faster.

[nixos-generators]: https://github.com/nix-community/nixos-generators 
[burn]: https://nixos.org/manual/nixos/stable/index.html#sec-booting-from-usb
[formats]: https://github.com/nix-community/nixos-generators/tree/master/formats

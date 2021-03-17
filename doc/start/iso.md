# ISO

Making and writing an installable iso for `hosts/NixOS.nix` is as simple as:
```sh
flk iso NixOS

dd bs=4M if=result/iso/*.iso of=/dev/$your_installation_device \
  status=progress oflag=sync
```

This works for any file matching `hosts/*.nix` excluding `default.nix`.

## ISO image nix store & cache

The iso image holds the store to the live environment and _also_ acts as a binay cache
to the installer. To considerably speed up things, the image already includes all flake
`inputs` as well as the `devshell` closures.

While you _could_ provision any machine with a single stick, a bespoke iso maximises
those local cache hits.

For hosts that don't differ too much, a common usb stick might be ok, whereas when
there are bigger differences, a bespoke usb stick will be considerably faster.


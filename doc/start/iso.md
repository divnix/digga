# ISO

Making and writing an installable iso for `hosts/bootstrap.nix` is as simple as:
```sh
bud build bootstrap bootstrapIso
sudo -E $(which bud) burn
```

This works for any host.

## ISO image nix store & cache

The iso image holds the store to the live environment and _also_ acts as a binary cache
to the installer. To considerably speed up things, the image already includes all flake
`inputs` as well as the `devshell` closures.

While you _could_ provision any machine with a single stick, a custom-made iso for
the host you want to install DevOS to, maximises those local cache hits.

For hosts that don't differ too much, a single usb stick might be ok, whereas when
there are bigger differences, a custom-made usb stick will be considerably faster.


# ISO

Making and writing an installable iso for `hosts/NixOS.nix` is as simple as:
```sh
flk iso NixOS

dd bs=4M if=result/iso/*.iso of=/dev/$your_installation_device \
  status=progress oflag=sync
```

This works for any file matching `hosts/*.nix` excluding `default.nix`.

## Bootstrap Target Machine

Once your target host has booted into the live iso, you need to partion
and format your disk according to the [official manual][manual].

Then properly mount the formatted partitions at `/mnt`, so that you can
install your system to those new partitions.

Mount `nixos` partition to `/mnt` and &mdash; for UEFI &mdash; `boot` 
partition to `/mnt/boot`:

```console
$ mount /dev/disk/by-label/nixos /mnt
$ mkdir -p /mnt/boot && mount /dev/disk/by-label/boot /mnt/boot # UEFI only
$ swapon /dev/$your_swap_partition
```

Install using the `flk` wrapper baked into the iso off of a copy of devos 
from the time the iso was built:

```console
$ cd /iso/devos
$ nix develop
$ flk install NixOS --impure # use same host as above
```

_Note: You _could_ install another machine than the one your iso was built for,
but the iso doesn't necesarily already carry all the necesary build artifacts._

<!-- TODO: find out why --impure is necesary / PRs welcome! -->

[manual]: https://nixos.org/manual/nixos/stable/index.html#sec-installation-partitioning

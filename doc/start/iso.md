# ISO

Making and writing an installable iso for `hosts/NixOS.nix` is as simple as:
```sh
flk iso NixOS

dd bs=4M if=result/iso/*.iso of=/dev/$your_installation_device \
  status=progress oflag=sync
```

_Note: You can use `lsblk` to better identify `$your_installation_device` and
it's current partitions._

This works for any file matching `hosts/*.nix` excluding `default.nix`.

# SD Card (aarch64 / armv7l)

Making and writing a bespoke sd card for `hosts/NixOS.nix` is as simple as:
```sh
flk sdaarch64 NixOS # aarch64 variant, or
flk sdarmv7l NixOS # armv7l variant

dd bs=4M if=result/sd/*.iso of=/dev/$your_sd_card \
  status=progress oflag=sync
```

- The `aarch64` variant is typically used for Raspberry Pi 3 and later models.
- The `armv7l` variant is typically used for Raspberry Pi 2 or 3.

This works for any file matching `hosts/*.nix` excluding `default.nix`.

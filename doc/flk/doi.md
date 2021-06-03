# DigitalOcean

Now you can [create a droplet](https://cloud.digitalocean.com/droplets/new) using your custom image.

Making a DigitalOcean compatible image for `hosts/NixOS.nix` is as simple as:
```sh
flk doi NixOS
```

This works for any file matching `hosts/*.nix` excluding `default.nix`.

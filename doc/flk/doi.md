# DigitalOcean

Now you can [create a droplet](https://cloud.digitalocean.com/droplets/new) using your custom image.

Making a DigitalOcean compatible image for `hosts/NixOS.nix` is as simple as:
```sh
flk doi DigitalOcean
```

This works for any file matching `hosts/*.nix` excluding `default.nix`.

## Deployment

DigitalOcean droplet can be managed with [deploy-rs](../integrations/deploy.md).

```sh
deploy "$DEVSHELL_ROOT#DigitalOcean" --hostname $ip_addr --ssh-user nixos --skip-checks --magic-rollback false
```

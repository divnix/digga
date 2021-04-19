# Bootstrapping

This will help you boostrap a bare host with the help of the
[bespoke iso](./iso.md) live installer.

_Note: nothing prevents you from remotely executing the boostrapping
process. See below._

Once your target host has booted into the live iso, you need to partion
and format your disk according to the [official manual][manual].

## Mount partitions

Then properly mount the formatted partitions at `/mnt`, so that you can
install your system to those new partitions.

Mount `nixos` partition to `/mnt` and &mdash; for UEFI &mdash; `boot`
partition to `/mnt/boot`:

```console
$ mount /dev/disk/by-label/nixos /mnt
$ mkdir -p /mnt/boot && mount /dev/disk/by-label/boot /mnt/boot # UEFI only
$ swapon /dev/$your_swap_partition
```

## Install

Install using the `flk` wrapper baked into the iso off of a copy of devos
from the time the iso was built:

```console
$ cd /iso/devos
$ nix develop
$ flk install NixOS --impure # use same host as above
```

<!-- TODO: find out why --impure is necesary / PRs welcome! -->

## Notes of interest

### Remote access to the live installer

The iso live installer comes preconfigured with a network configuration
which announces it's hostname via [MulticastDNS][mDNS] as `hostname.local`,
that is `NixOS.local` in the [iso example](./iso).

In the rare case that [MulticastDNS][mDNS] is not availabe or turned off
in your network, there is a static link-local IPv6 address configured to
`fe80::47`(mnemonic from the letter's position in the english alphabet:
`n=14 i=9 x=24; 47 = n+i+x`).

Provided that you have added your public key to the authorized keys of the
`root` user _(hint: [`deploy-rs`](../integrations/deploy.md) needs passwordless
sudo access)_:

```nix
{ ... }:
{
  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../secrets/path/to/key.pub
  ];
}
```

You can then ssh into the live installer through one of the
following options:

```console
ssh root@NixOS.local

ssh root@fe80::47%eno1  # where eno1 is your network interface on which you are linked to the target
```

_Note: the [static link-local IPv6 address][staticLLA] and [MulticastDNS][mDNS] is only
configured on the live installer. If you wish to enable [MulticastDNS][mDNS]
for your environment, you ought to configure that in a regular [profile](../concepts/profiles.md)._

### EUI-64 LLA & Host Identity

The iso's IPv6 Link Local Address (LLA) is configured with a static 64-bit Extended
Unique Identifiers (EUI-64) that is derived from the host interface's Message
Authentication Code (MAC) address.

After a little while (a few seconds), you can remotely discover this unique and host
specific address over [NDP][NDP] for example with:

```console
ip -6 neigh show # also shows fe80::47
```

***This LLA is stable for the host, unless you need to swap that particular network card.***
Under this reservation, though, you may use this EUI-64 to wire up a specific
(cryptographic) host identity.


[manual]: https://nixos.org/manual/nixos/stable/index.html#sec-installation-partitioning
[mDNS]: https://en.wikipedia.org/wiki/Multicast_DNS
[NDP]: https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol
[staticLLA]: https://tools.ietf.org/html/rfc7404

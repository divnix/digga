# Secrets
Secrets are managed using [git-crypt][git-crypt] and [agenix][agenix]
so you can keep your flake in a public repository like GitHub without
exposing your password or other sensitive data.

By default, everything in the secrets folder is automatically encrypted. Just
be sure to run `git-crypt init` before putting anything in here.

## Agenix
Currently, there is [no mechanism][secrets-issue] in nix itself to deploy secrets
within the nix store because it is world-readable.

Most NixOS modules have the ability to set options to files in the system, outside
the nix store, that contain sensitive information. You can use [agenix][agenix]
to easily setup those secret files declaratively.

[agenix][agenix] encrypts secrets and stores them as .age files in your repository.
Age files are encrypted with multiple ssh public keys, so any host or user with a
matching ssh private key can read the data. The [age module][age module] will add those
encrypted files to the nix store and decrypt them on activation to `/run/secrets`.

### Setup
All hosts must have openssh enabled, this is done by default in the core profile.

You need to populate your `secrets/secrets.nix` with the proper ssh public keys.
Be extra careful to make sure you only add public keys, you should never share a
private key!!

secrets/secrets.nix:
```nix
let
  system = "<system ssh key>";
  user = "<user ssh key>";
  allKeys = [ system user ];
in
```

On most systems, you can get your systems ssh public key from `/etc/ssh/ssh_host_ed25519_key.pub`. If
this file doesn't exist you likely need to enable openssh and rebuild your system.

Your users ssh public key is probably stored in `~/.ssh/id_ed25519.pub` or
`~/.ssh/id_rsa.pub`. If you haven't generated a ssh key yet, be sure do so:
```sh
ssh-keygen -t ed25519
```

> ##### _Note:_
> The underlying tool used by agenix, rage, doesn't work well with password protected
> ssh keys. So if you have lots of secrets you might have to type in your password many
> times.


### Secrets
You will need the `agenix` command to create secrets. DevOS conveniently provides that
in the devShell, so just run `nix develop` whenever you want to edit secrets. Make sure
to always run `agenix` while in the `secrets/` folder, so it can pick up your `secrets.nix`.

To create secrets, simply add lines to your `secrets/secrets.nix`:
```
let
  ...
  allKeys = [ system user ];
in
{
  "secret.age".publicKeys = allKeys;
}
```
That would tell agenix to create a `secret.age` file that is encrypted with the `system`
and `user` ssh public key.

Then go into the `secrets` folder and run:
```sh
agenix -e secret.age
```
This will create the `secret.age`, if it doesn't already exist, and allow you to edit it.

If you ever change the `publicKeys` entry of any secret make sure to rekey the secrets:
```sh
agenix --rekey
```

### Usage
Once you have your secret file encrypted and ready to use, you can utilize the [age module][age module]
to ensure that your secrets end up in `/run/secrets`.

In any profile that uses a NixOS module that requires a secret you can enable a particular secret like so:

```nix
{ self, ... }:
{
  age.secrets.mysecret.file = "${self}/secrets/mysecret.age";
}
```


Then you can just pass the path `/run/secrets/mysecret` to the module.

You can make use of the many options provided by the age module to customize where and how
secrets get decrypted. You can learn about them by looking at the
[age module][age module].


> ##### _Note:_
> You can take a look at the [agenix repository][agenix] for more information
> about the tool.

[git-crypt]: https://github.com/AGWA/git-crypt
[agenix]: https://github.com/ryantm/agenix
[age module]: https://github.com/ryantm/agenix/blob/master/modules/age.nix
[secrets-issue]: https://github.com/NixOS/nix/issues/8

# Secrets
Secrets are managed using [git-crypt][git-crypt] so you can keep your flake in
a public repository like GitHub without exposing your password or other
sensitive data.

By default, everything in the secrets folder is automatically encrypted. Just
be sure to run `git-crypt init` before putting anything in here.

> ##### _Note:_
> Currently, there is [no mechanism][secrets-issue] in nix to deploy secrets
> within the nix/store so, if they end up in the nix/store after deployment, they
> will be world readable on that machine.
>
> The author of devos intends to implement a workaround for this situation in
> the near future, but for the time being, simple be aware of this.

[git-crypt]: https://github.com/AGWA/git-crypt
[secrets-issue]: https://github.com/NixOS/nix/issues/8

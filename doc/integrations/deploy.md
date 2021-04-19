# deploy-rs
[Deploy-rs][d-rs] is a tool for managing NixOS remote machines. It was
chosen for devos after the author experienced some frustrations with the
stateful nature of nixops' db. It was also designed from scratch to support
flake based deployments, and so is an excellent tool for the job.

By default, all the [hosts](../concepts/hosts.md) are also available as deploy-rs nodes,
configured with the hostname set to `networking.hostName`; overridable via
the command line.

## Usage

Just add your ssh key to the host:
```nix
{ ... }:
{
  users.users.${sshUser}.openssh.authorizedKeys.keyFiles = [
    ../secrets/path/to/key.pub
  ];
}
```

And the private key to your user:
```nix
{ ... }:
{
  home-manager.users.${sshUser}.programs.ssh = {
    enable = true;

    matchBlocks = {
      ${host} = {
        host = hostName;
        identityFile = ../secrets/path/to/key;
        extraOptions = { AddKeysToAgent = "yes"; };
      };
    };
  }
}
```

And run the deployment:
```sh
deploy "flk#hostName" --hostname host.example.com
```

> ##### _Note:_
> Your user will need **passwordless** sudo access

[d-rs]: https://github.com/serokell/deploy-rs

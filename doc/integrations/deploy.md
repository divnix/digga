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
deploy '.#hostName' --hostname host.example.com
```

> ##### _Note:_
> Your user will need **passwordless** sudo access
### Home Manager

Digga's `lib.mkDeployNodes` provides only `system` profile.
In order to deploy your `home-manager` configuration you should provide additional profile(s) to deploy-rs config:
```nix
# Initially, this line looks like this: deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };
deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations
  {
    <HOSTNAME> = {
      profilesOrder = [ "system" "<HM_PROFILE>" "<ANOTHER_HM_PROFILE>"];
      profiles.<HM_PROFILE> = {
        user = "<YOUR_USERNAME>";
        path = deploy.lib.x86_64-linux.activate.home-manager self.homeConfigurationsPortable.x86_64-linux.<YOUR_USERNAME>;
      };
      profiles.<ANOTHER_HM_PROFILE> = {
        user = "<ANOTHER_USERNAME>";
        path = deploy.lib.x86_64-linux.activate.home-manager self.homeConfigurationsPortable.x86_64-linux.<ANOTHER_USERNAME>;
      };
    };
  };
```

Substitute `<HOSTNAME>`, `<HM_PROFILE>` and `<YOUR_USERNAME>` placeholders (omitting the `<>`). 

`<ANOTHER_HM_PROFILE>` is there to illustrate deploying multiple `home-manager` configurations. Either substitute those as well,
or remove them altogether. Don't forget the `profileOrder` variable.


[d-rs]: https://github.com/serokell/deploy-rs

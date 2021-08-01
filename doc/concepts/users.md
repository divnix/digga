> ##### _Note:_
> This  section and its semantics need a conceptiual rework.
> Since recently [portable home configurations][portableuser]
> that are not bound to any specific host are a thing.

# Users

Users are a special case of [profiles](profiles.md) that define system
users and [home-manager][home-manager] configurations. For your convenience,
home manager is wired in by default so all you have to worry about is declaring
your users. For a fully fleshed out example, check out the developers personal
[branch](https://github.com/divnix/devos/tree/nrd/users/nrd/default.nix).

## Basic Usage
`users/myuser/default.nix`:
```nix
{ ... }:
{
  users.users.myuser = {
    isNormalUser = true;
  };

  home-manager.users.myuser = {
    programs.mpv.enable = true;
  };
}

```

## Home Manager
Home Manager support follows the same principles as regular nixos configurations,
it even gets its own namespace in your `flake.nix` as `home`.

All modules defined in [user modules][modules-list] will be imported to
Home Manager.
User profiles can be collected in a similar fashion as system ones into a `suites`
argument that gets passed to your home-manager users.

### Example
```nix
{
  home-manager.users.nixos = { suites, ... }: {
    imports = suites.base;
  };
}
```


## External Usage
You can easily use the defined home-manager configurations outside of NixOS
using the `homeConfigurations` flake output. The [flk](../flk/index.md) helper
script makes this even easier.

This is great for keeping your environment consistent across Unix systems,
including OSX.

### From within the projects devshell:
```sh
# builds the nixos user defined in the NixOS host
flk home NixOS nixos

# build and activate
flk home NixOS nixos switch
```

### Manually from outside the project:
```sh
# build
nix build "github:divnix/devos#homeConfigurations.nixos@NixOS.home.activationPackage"

# activate
./result/activate && unlink result
```

[home-manager]: https://nix-community.github.io/home-manager
[modules-list]: https://github.com/divnix/devos/tree/core/users/modules/module-list.nix
[portableuser]: https://digga.divnix.com/api-reference-home.html#homeusers

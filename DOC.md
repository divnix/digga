## Hosts
Module declarations dependant on particular machines should be stored in the
[hosts](hosts) directory. Every file in this directory will be added automatically
to the the `nixosConfigurations` flake output and thus becomes deployable via
`nixos-rebuild` and `flk`.

See [`hosts/default.nix`](hosts/default.nix) for the implementation.

## Profiles
A profile is any directory under [profiles](profiles) containing a `default.nix`
defining a function that returns a valid NixOS module, with the added restriction
that no new declarations to the `options` _or_ `config` attributes are allowed
(use [modules](modules) instead). Their purpose is to provide abstract
expressions suitable for reuse by multiple deployments. They are perhaps _the_
key mechanism by which we keep this repo maintainable.

Profiles can have subprofiles which are themselves just profiles that live under
another. There's no hard rule that everything in the folder must be imported by
its `default.nix`, so you can also store relevant code that is useful but not
wanted by default in, say, an `alt.nix`. Importantly, every subdirectory in a
profile should be independent of its parent. i.e:

```nix
{
  # importing `profile` without implicitly importing `some`
  imports = [ ./profiles/some/profile ];
}
```

It is okay for profiles to depend on other profiles so long as they are
explicitly loaded via `imports`.

## Suites

[Suites](./suites/default.nix) are simple collections of profiles that can be
directly imported from any host like so:
```
{ suites, ... }:
{
  imports = suites.mySuite;
}
```

You can declare any combination of users and profiles that you wish, providing
a nice abstraction, free from the idiosyncratic concerns of specific hardware.

## Users
User declarations belong in the `users` directory.

These are actually just a special case of [profiles](#profiles) attached to
a particular interactive user. Its primarily for declarations to
`users.users.<new-user>` where `<new-user>.isNormalUser` is true.

This is a convenient place to import your profiles such that a particular user
always has a reliable stack. Also [user profiles](./users/profiles) are
available to create reusable configs across different users.

For convenience, [home-manager][home-manager] is available automatically for
home directory setup and should only be used from this directory.

## Secrets
Anything you wish to keep encrypted goes in the `secrets` directory, which is
created on first entering a `nix-shell`.

Be sure to run `git crypt init`, before committing anything to this directory.
Be sure to check out git-crypt's [documentation](https://github.com/AGWA/git-crypt)
if your not familiar. The filter is already set up to encrypt everything in this
folder by default.

To keep [profiles](profiles) reusable across configurations, secrets should
only be imported from the `users` or [`hosts`](hosts) directory.

## Cachix
When using:
```
cachix use <your-cachix>
```
A file with be created in `/etc/nixos/cachix/your-cachix.nix`. Simply add this
file to git, and it will be exported so others can use your binary cache
directly from this flake via `nixosModules.cachix.<your-cachix>`.


## Modules, Packages and Overlays
All expressions in both [modules/list.nix](modules/list.nix) and
[pkgs/default.nix](pkgs/default.nix) are available globally, anywhere else in the
repo. They are additionally included in the `nixosModules` and `overlay` flake
outputs, respectively. Packages are automatically included in the `packages`
output as well.

The directory structure is identical to nixpkgs to provide a kind of staging area
for any modules or packages we might be wanting to merge there later. If your not
familiar or can't be bothered, simply dropping a valid nix file and pointing the
`default.nix` to it, is all that's really required.

As for overlays, they should be defined in the [overlays](overlays) directory.
They will be automatically pulled in for use by all configurations. Nix command
line tools will be able to read overlays from here as well since it is set as
`nixpkgs-overlays` in `NIX_PATH`. And of course they will be exported via the
flake output `overlays` as well.

If you wish to use an overlay from an external flake, simply add it to the
`externOverlays` list in the `let` block of the `outputs` attribute in
[flake.nix](flake.nix). Same for external modules, add them to `externModules`.

[home-manager]: https://github.com/nix-community/home-manager

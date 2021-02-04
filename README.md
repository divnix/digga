> Since flakes are still quite new, I've listed some learning resources
> [below](#resources).

# Introduction
Herein lies a [NixOS][NixOS] configuration template using the new [flakes][wiki]
mechanism. Its aim is to provide a generic repository which neatly separates
concerns and allows one to get up and running with NixOS faster than ever, while
keeping your code clean and organized.

Some key advantages include:
* A single home for all your Nix expressions, easily sharable and portable!
* Skip the boilerplate, simply use the included [nix-shell](./shell.nix) or
  [direnv][direnv] profile and get up and running with flakes right away.
* Thanks to flakes, the entire system is more [deterministic](./flake.lock).
* Systems defined under [hosts](./hosts) are automatically imported into
  `nixosConfigurations`, ready to deploy.
* [Profiles](./profiles/list.nix) are a simple mechanism for using portable
  code across machines.
* Defined [packages](./pkgs/default.nix) and
  [modules](./modules/list.nix), are automatically wired and available from
  anywhere. They are _also_ sharable via their respective flake outputs.
* Easily [override](./unstable/default.nix) packages from different nixpkgs
  versions.
* Keep [user](./users) configuration isolated and easily reusable by taking
  advantage of [user profiles](./users/profiles) and [home-manager][home-manager].
* [Overlay](./overlays) files are automatically available and sharable.
* Automatic [NUR][nur] support.

For a more detailed explanation of the code structure, check out the
[docs](./DOC.md).

### ⚠ Advisory
Flakes are still new, so not everything works yet. However, it has been to
merged in [nixpkgs][nixpkgs] via [`pkgs.nixFlakes`][nixFlakes]. Thus, this
project should be considered _experimental_, until flakes become the default.

Also, flakes are meant to deprecate nix-channels. It's recommended not to
install any. If your really want them, they should work if you hook them into
`NIX_PATH`.

# Setup
There are a few ways to get up and running. You can fork this repo or use it as
a template. There is a [community][community] branch with a bunch of useful
profiles, modules, overlays, etc, already configured for you to use. Please
consider adding your own expressions there if you feel they would be helpful
for others.

The only hard requirement is nix itself. The `shell.nix` will pull in
everything else.

## Flake Templates
If you already have [nix-command][nix-command] setup you can:
```sh
# for the core template with no profiles
nix flake new -t "github:nrdxp/nixflk" flk

# for the community template
nix flake new -t "github:nrdxp/nixflk/community" flk
```

## Nix Only
Once you have this repo, you'll want to __move or symlink__ it to `/etc/nixos`
for ease of use. Once inside:
```sh
# probably want to use a separate branch for you config
git checkout -b my-branch

# This will setup nix-command and pull in the needed tools
nix-shell # or `direnv allow` if you prefer

# use nixos-generate-config to generate a basic config for your system
# edit hosts/up-$(hostname).nix to modify.
flk up

# The following should work fine for EFI systems.
# boot.loader.systemd-boot.enable = true;
# boot.loader.efi.canTouchEfiVariables = true;

# Set your locale
$EDITOR local/locale.nix

# install NixOS to bare metal
flk install yourConfig # deploys hosts/yourConfig.nix

# if you already have NixOS and just want to deploy your new setup
flk yourConfig switch
```

### Note on `flk up`:
While the `up` sub-command is provided as a convenience to quickly set up and
install a "fresh" NixOS system on current hardware, committing these files is
discouraged.

They are placed in the git staging area automatically because they would be
invisible to the flake otherwise, but it is best to move what you need from
them directly into your hosts file and commit that instead.

# Sharing
One of the great benefits of flakes is the ability to easily share your user
defined packages, modules and other nix expressions without having to merge
anything upstream. In that spirit, everything defined in this flake is usable
from other flakes. So even if you don't want to use this project as a template,
you can still pull in any useful modules, packages or profiles defined here.

From the command line:
```sh
# to see what this flake exports
nix flake show "github:nrdxp/nixflk"

# run an app
nix run "github:nrdxp/nixflk#someApp"

# start a dev shell for a given derivation
nix develop "github:nrdxp/nixflk#somePackage"

# a nix shell with the package in scope
nix shell "github:nrdxp/nixflk#somePackage"
```

From within a flake:
```nix
{
  inputs.nixflk.url = "github:nrdxp/nixflk";

  outputs = { self, nixpkgs, nixflk, ... }:
  {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      # ...
        modules = [
        nixflk.nixosModules.someModule
        ({
          nixpkgs.overlays = [ nixflk.overlay nixflk.overlays.someOverlay ];
        })
        # ...
      ];
    };
  };
}
```

## Home Manager Integration
The home-manager nixos module is available for each host. It is meant
to be used in the user profiles, you can find an example in the nixos user profile

The home-manager configuration for each user in each system is available in the
outputs as homeConfigurations and the activation packages in hmActivationPackages.

This allows you to just build the home-manager environment without the rest of the
system configuration. The feature is useful on systems without nixos or root access.

Lets say you want to activate the home configuration for the user `nixos` in the
host `NixOS`.

With the flk script:
```sh
# You can build it using
flk home NixOS nixos
# and activate with
./result/activate

# Or do both like this
flk home NixOS nixos switch
```

## Build an ISO

You can make an ISO out of any config:
```sh
flk iso yourConfig # build an iso for hosts/yourConfig.nix
```

## Hardware Specific Profile for a Single Host

Find out the fitting
[nixos-hardware profile](https://github.com/NixOS/nixos-hardware#list-of-profiles)
for the hardware of your host, then find the corresponding modules in the
[flake](https://github.com/NixOS/nixos-hardware/blob/master/flake.nix) and add
it to the configuration. For example for a Dell XPS 13 9370 the host
configuration would contain:
```nix
{ hardware, ... }:
{
  imports = [ hardware.dell-xps-13-9370 ... ];
  ...
}
```

## Use a Package from NUR

NUR is wired in from the start. For safety, nothing is added from it by default,
but you can easily pull packages from inside your configuration like so:
```nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ nur.repos.<owner>.<package> ];
}
```
# Resources

## Links
* [Example Repo](https://github.com/colemickens/nixos-flake-example)
* [Tweag.io _Flakes_ Blog Series](https://www.tweag.io/blog/2020-05-25-flakes)
* [NixOS _Flakes_ Wiki](https://nixos.wiki/wiki/Flakes)
* [Zimbatm's _Flakes_ Blog](https://zimbatm.com/NixFlakes)
* [Original RFC](https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md)

## Flake Talk:
[![Flake talk at NixConf][thumb]][video]


# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.

[community]: https://github.com/nrdxp/nixflk/tree/community
[direnv]: https://direnv.net
[home-manager]: https://github.com/nix-community/home-manager
[nix-command]: https://nixos.wiki/wiki/Nix_command
[nixFlakes]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/package-management/nix/default.nix#L211
[NixOS]: https://nixos.org
[nixpkgs]: https://github.com/NixOS/nixpkgs
[nur]: https://github.com/nix-community/NUR
[wiki]: https://nixos.wiki/wiki/Flakes
[thumb]: https://img.youtube.com/vi/UeBX7Ide5a0/hqdefault.jpg
[video]: https://www.youtube.com/watch?v=UeBX7Ide5a0
[nur]: https://github.com/nix-community/NUR

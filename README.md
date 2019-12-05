# Introduction

This project is under construction as a rewrite of my [legacy][old]
NixOS configuration, using the [experimental][rfc] _flakes_ mechanism.


#### [Flake Talk][video]




## [setup][pr]:
```nix
  {

    nix.package = nixFlakes;

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

  }
```

### sans [NixOS][nixos]:
```
  # nix-env -f '<nixpkgs>' -iA nixFlakes

  # echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
```




# License

This software is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by this configuration,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included here, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.

[rfc]: https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md
[pr]:  https://github.com/NixOS/nixpkgs/pull/68897
[video]: https://www.youtube.com/watch?v=UeBX7Ide5a0
[NixOS]: https://nixos.org
[old]: https://github.com/nrdxp/nixos

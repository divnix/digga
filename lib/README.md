# Lib
The lib directory mirrors the upstream concepts of [`nixpkgs:./lib`][nixpkgs-lib], 
[`nixpkgs:./nixos/lib`][nixpkgs-nixos-lib] and [`nixpkgs:./pkgs/pkgs-lib`][nixpkgs-pkgs-lib],
but also occasionally [`nixpkgs:./pkgs/build-support`][nixpkgs-pkgs-build-support].

It comes with functions necesary to declutter `devos` itself, but you are
welcome to extend it to your needs.

For example:

- you want to add a library function that depends on some packages
and use it throughout your devos environment: place it into `./lib`
as if you would place it into [`nixpkgs:./pkgs/pkgs-lib`][nixpkgs-pkgs-lib].

- you want to add library functions that don't depend on `pkgs`: place
them into `./lib` as if you would place them into [`nixpkgs:./lib`][nixpkgs-lib].

- need to try out a newish custom build support: place it here before
upstreaming into [`nixpkgs:./pkgs/build-support`][nixpkgs-pkgs-build-support].

- you want to reutilize certain module configuration functions or helpers:
place them into `./lib` as if you would place them into [`nixpkgs:./nixos/lib`][nixpkgs-nixos-lib].

Once your library grows, we recoomend you start organizing them into subfolders
analogous `nixpkgs`:

| `nixpkgs`              | `devos`            |
| ---------------------- | ------------------ |
| `./lib`                | `./lib`            |
| `./pkgs/pkgs-lib`      | `./lib/pkgs-lib`   |
| `./nixos/lib`          | `./lib/nixos-lib`  |
| `./pkgs/build-support` | `./lib/pkgs-build` |


## Example
lib/nixos-lib/mkCustomI3BindSym/default.nix:
```nix
{ pkgs, writers, ... }:
{ name, cmd, workspace, baseKey }:
let
  isWorkspaceEmpty = writers.writePython3 "is-workspace-empty" {
    libraries = [ pkgs.python3Packages.i3ipc ];
  } (builtins.readFile ./is-workspace-empty.py);

  ws = builtins.toString workspace;
in
''

  # ${name}
  #bindsym ${baseKey}+${ws} workspace ${ws}; exec ${cmd}
  bindsym ${baseKey}+${ws} workspace ${ws}; exec bash -c "${isWorkspaceEmpty} && ${cmd}"
''
```

lib/nixos-lib/mkCustomI3BindSym/is-workspace-empty.py:
```python
# returns 0/1 if current workspace is empty/non-empty

import i3ipc

i3 = i3ipc.Connection()
tree = i3.get_tree()


def current_workspace():
    return tree.find_focused().workspace()


if current_workspace().leaves():
    print("Error current workspace is not empty")
    exit(1)
exit(0)
```

lib/default.nix:
```nix
{ nixos, pkgs, ... }:
# ...
{
  # ...
  mkCustomI3BindSym = pkgs.callPackage ./nixos-lib/mkCustomI3BindSym { };
}
```

[nixpkgs-lib]: https://github.com/NixOS/nixpkgs/tree/master/lib
[nixpkgs-pkgs-lib]: https://github.com/NixOS/nixpkgs/tree/master/pkgs/pkgs-lib
[nixpkgs-pkgs-build-support]: https://github.com/NixOS/nixpkgs/tree/master/pkgs/build-support
[nixpkgs-nixos-lib]: https://github.com/NixOS/nixpkgs/tree/master/nixos/lib

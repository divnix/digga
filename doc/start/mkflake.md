# Use Devos as a library!
You can also add devos as a flake input and use its library function, `mkFlake` to 
create your flake. This gives you the advantage of using nix flakes to sync with 
upstream changes in devos.

You can either use the default template or use the 'mkflake' template which only
includes the necessary folders for `mkFlake` usage. It can be pulled with:
```sh
nix flake init -t github:divnix/devos#mkflake
```

Once you have a template, you need to add devos as a flake input, which would look
like this:
```nix
inputs = {
  ...
  devos.url = "github:divnix/devos";
};
```
> ##### Note:
> - All devos inputs must still be included in your flake, due to a nix
>   [issue](https://github.com/NixOS/nix/pull/4641) with the `follows` attribute.
> - You can append `/community` to access community modules [extern](../../extern).

You can then call `mkFlake` to create your outputs. Here is a simple example:
```nix
outputs = { self, devos, ... }: devos.lib.mkFlake { 
  inherit self; 
  hosts = ./hosts;
};
```
`mkFlake` has various arguments to include more devos concepts like suites and profiles.
These options are documented in [mkFlakeOptions](../mkFlakeOptions.md).

The devos template itself uses mkFlake to export its own outputs, so you can take
a look at this repository's [flake.nix](../../flake.nix) for a more realistic use
of `mkFlake`.

You can now sync with upstream devos changes just like any other flake input. But
you will no longer be able to edit devos's internals, since you are directly following
upstream devos changes.


# Use mkDevos
You can also use devos as a flake input and get the advantage of using
nix flakes to sync with upstream changes in devos.

You can either use the default template or use the 'mkdevos' template which only
includes the necessary files for `mkDevos` usage. It can be pulled with:
```sh
nix flake init -t github:divnix/devos#mkdevos
```

Once you have a template, edit your flake.nix to add devos as an input:
```nix
inputs = {
  ...
  devos.url = "github:divnix/devos";
};
```
then replace the outputs section with this:
```nix
outputs = { self, devos, ... }: devos.lib.mkDevos { inherit self; };
```

Now you can sync with upstream devos changes just like any other flake input.

If you would like to change your directory's structure, you can pass
arguments to `mkDevos` to outline where certain things are. You can take a 
look at [evalDevosArgs](../../lib/devos/evalDevosArgs.nix) to learn about
the arguments that it can take.

> ##### Notes:
> - All inputs used in devos must also be added to your flake, due to an
>   [issue](https://github.com/NixOS/nix/pull/4641) with the `follows` attribute.
> - You can append `/community` to the `devos.url` to get access to community modules
>   and packages which can be added in [extern](../../extern).
> - Many folders in devos will no longer be needed and can, optionally, be deleted.
> - To use community profiles, you will have to copy them to your tree
> - If you use this method, you will no longer be able to edit devos internals.

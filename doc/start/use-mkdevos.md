# Use mkDevos
You can also use devos as a flake input and get the advantage of using
nix flakes to sync with upstream changes in devos.

To do this you will need the template and nix unstable. Edit your flake.nix to
add devos as an input:
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

Now you can update devos as you would any other flake input:
```sh
nix flake update --update-input devos
```

If you would like to change your directory's structure, you can pass
arguments to `mkDevos` to outline where certain things are. You can take a 
look at [evalDevosArgs](../../lib/devos/evalDevosArgs.nix) to learn about
the arguments that it can take.

> ##### Notes:
> - All inputs used in devos must also be added to your flake, due to an
>   [issue](https://github.com/NixOS/nix/pull/4641) with the `follows` attribute.
> - Optionally, you can safely delete [lib](../../lib), [tests](../../tests) and
>   the [core profile](../../profiles/core)
> - You can append `/community` to the `devos.url` to get access to community modules
>   which can be added in [extern](../../extern).
> - To use community profiles, you will have to copy them to your tree
> - If you use this method, you will no longer be able to edit devos internals.

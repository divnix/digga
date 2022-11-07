{ self, inputs, ... }:
{
  modules = with inputs; [ ];
  exportedModules = [
    ./devos.nix
  ];
}


{ lib, deploy, devshell, home-manager } @ injectedDeps:

{ self, inputs, ... } @ args:
let

  options' = import ./options.nix injectedDeps;
  fupAdapter' = import ./fup-adapter.nix injectedDeps;
  defaultOutputsBuilder' = import ./outputs-builder.nix injectedDeps;

  evaled = lib.evalModules {
    modules = [
      args
      options'
    ];
  };

  defaultOutputsBuilder = defaultOutputsBuilder' evaled.config;

  extraArgs = removeAttrs args (builtins.attrNames evaled.options);

in
fupAdapter' {
  inherit (evaled) config;
  inherit extraArgs defaultOutputsBuilder;
}

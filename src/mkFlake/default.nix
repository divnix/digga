{
  lib,
  deploy,
  devshell,
  home-manager,
  flake-utils-plus,
  flake-utils,
  internal-modules,
  tests,
} @ injectedDeps: {
  self,
  inputs,
  ...
} @ args: let
  # avoid infinite recursions w.r.t. using self or inputs in imports
  injectedDeps' = injectedDeps // {inherit self inputs;};

  options' = import ./options.nix injectedDeps';
  fupAdapter' = import ./fup-adapter.nix injectedDeps';
  defaultOutputsBuilder' = import ./outputs-builder.nix injectedDeps';

  evaled = lib.evalModules {modules = [args options'];};

  defaultOutputsBuilder = defaultOutputsBuilder' evaled.config;

  extraArgs = removeAttrs args (builtins.attrNames evaled.options);
in {
  flake = fupAdapter' {
    inherit (evaled) config;
    inherit extraArgs defaultOutputsBuilder;
  };

  options = options';
}

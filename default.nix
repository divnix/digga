let
  inherit (default.inputs.nixos.lib) recurseIntoAttrs;

  default = (import ./compat).defaultNix;
in
builtins.mapAttrs (_: v: recurseIntoAttrs v) default.packages // {
  shell = import ./shell.nix;
}

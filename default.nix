let
  inherit (default.inputs.nixos) lib;

  default = (import ./compat).defaultNix;
in
builtins.mapAttrs (_: v: lib.recurseIntoAttrs v) default.packages // {
  shell = import ./shell.nix;
}

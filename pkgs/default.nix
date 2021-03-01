{ nixos }: final: prev: {
  myLib = import ../lib { inherit nixos; pkgs = final; };
}

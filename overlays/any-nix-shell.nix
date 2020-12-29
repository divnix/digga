final: prev: {
  any-nix-shell = prev.any-nix-shell.overrideAttrs
    (o: {
      patches = [ ../profiles/develop/zsh/patches/0001-nix-run-is-now-nix-shell-semantically.patch ];
    });
}

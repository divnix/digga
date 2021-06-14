final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./sources.nix) { };
  # then, call packages with `final.callPackage`
}

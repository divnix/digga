final: prev: {
  manix = prev.manix.overrideAttrs (o: rec {
    inherit (prev.sources.manix) pname version src;
  });
}

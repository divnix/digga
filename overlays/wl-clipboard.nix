final: prev: {
  # nixpkgs version causing issues for me
  wl-clipboard = prev.wl-clipboard.overrideAttrs (o: {
    src = prev.fetchFromGitHub {
      owner = "bugaevc";
      repo = "wl-clipboard";
      rev = "c010972e6b0d2eb3002c49a6a1b5620ff5f7c910";
      sha256 = "020l3jy9gsj6gablwdfzp1wfa8yblay3axdjc56i9q8pbhz7g12j";
    };
  });
}

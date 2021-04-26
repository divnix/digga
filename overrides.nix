channels: final: prev: {

  inherit (channels.latest)
    cachix
    dhall
    discord
    element-desktop
    manix
    nixpkgs-fmt
    qutebrowser
    signal-desktop
    starship;


  haskellPackages = prev.haskellPackages.override {
    overrides = hfinal: hprev:
      let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
      in
      {
        # same for haskell packages, matching ghc versions
        inherit (channels.latest.haskell.packages."ghc${version}")
          haskell-language-server;
      };
  };

}

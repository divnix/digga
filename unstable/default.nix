{
  # modules to pull from master, stable version is automatically disabled
  modules = [ ];

  # if a modules name changed in master, add the old name here
  disabledModules = [ ];

  # packages pulled from master
  packages = pkgs: final: prev: {
    inherit (pkgs)
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
          inherit (pkgs.haskell.packages."ghc${version}")
            haskell-language-server;
        };
    };
  };
}

# Packages inherited are imported in hosts/default.nix, and are pulled from
# nixpkgs master instead of the default nixos release. This doesn't actually
# install them, just creates an overlay to pull them from master if they are
# installed by the user elsewhere in the configuration.
pkgs: final: prev:
{
  inherit (pkgs)
    manix;

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
}

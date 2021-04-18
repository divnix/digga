{ lib }:
{
  # pkgImport :: Nixpkgs -> Overlays -> System -> Pkgs
  pkgImport = nixpkgs: overlays: system:
    import nixpkgs {
      inherit system overlays;
      config = { allowUnfree = true; };
    };

  profileMap = map (profile: profile.default);

  mkNodes = lib.callLibs ./mkNodes.nix;

  mkHosts = lib.callLibs ./mkHosts.nix;

  mkSuites = lib.callLibs ./mkSuites.nix;

  mkProfileAttrs = lib.callLibs ./mkProfileAttrs.nix;

  mkPkgs = lib.callLibs ./mkPkgs.nix;

  recImport = lib.callLibs ./recImport.nix;

  devosSystem = lib.callLibs ./devosSystem.nix;

  mkHomeConfigurations = lib.callLibs ./mkHomeConfigurations.nix;

  mkPackages = lib.callLibs ./mkPackages.nix;
}


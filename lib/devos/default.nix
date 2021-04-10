{ lib, nixos, dev, ... }:
{
  # pkgImport :: Nixpkgs -> Overlays -> System -> Pkgs
  pkgImport = nixpkgs: overlays: system:
    import nixpkgs {
      inherit system overlays;
      config = { allowUnfree = true; };
    };

  profileMap = list: map (profile: profile.default) (lib.flatten list);

  mkNodes = dev.callLibs ./mkNodes.nix;

  mkHosts = dev.callLibs ./mkHosts.nix;

  mkSuites = dev.callLibs ./mkSuites.nix;

  mkProfileAttrs = dev.callLibs ./mkProfileAttrs.nix;

  mkPkgs = dev.callLibs ./mkPkgs.nix;

  recImport = dev.callLibs ./recImport.nix;

  devosSystem = dev.callLibs ./devosSystem.nix;

  mkHomeConfigurations = dev.callLibs ./mkHomeConfigurations.nix;

  mkPackages = dev.callLibs ./mkPackages.nix;
}


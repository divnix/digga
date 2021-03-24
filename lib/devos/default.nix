{ lib, nixos, dev, ... }:
{
  # pkgImport :: Nixpkgs -> Overlays -> System -> Pkgs
  pkgImport = nixpkgs: overlays: system:
    import nixpkgs {
      inherit system overlays;
      config = { allowUnfree = true; };
    };

  importIf = path: if builtins.isPath path || builtins.isString path
    then import path else path;

  profileMap = map (profile: profile.default);

  evalDevosArgs = dev.callLibs ./evalDevosArgs.nix;

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


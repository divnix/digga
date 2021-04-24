{ lib, utils }:
{
  # pkgImport :: Nixpkgs -> Overlays -> System -> Pkgs
  pkgImport = nixpkgs: overlays: system:
    import nixpkgs {
      inherit system overlays;
      config = { allowUnfree = true; };
    };

  profileMap = list: map (profile: profile.default) (lib.flatten list);

  mkNodes = import ./mkNodes.nix { inherit lib; };

  mkHosts = import ./mkHosts.nix { inherit lib; };

  mkSuites = import ./mkSuites.nix { inherit lib; };

  mkProfileAttrs = import ./mkProfileAttrs.nix { inherit lib; };

  mkPkgs = import ./mkPkgs.nix { inherit lib utils; };

  recImport = import ./recImport.nix { inherit lib; };

  devosSystem = import ./devosSystem.nix { inherit lib; };

  mkHomeConfigurations = import ./mkHomeConfigurations.nix { inherit lib; };

  mkPackages = import ./mkPackages.nix { inherit lib; };
}


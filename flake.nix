{
  description = "A highly structured configuration database.";

  inputs.nixpkgs.url = "nixpkgs/release-20.03";
  inputs.unstable.url = "nixpkgs/master";
  inputs.home.url = "github:rycee/home-manager/bqv-flakes";

  outputs = inputs@{ self, home, nixpkgs, unstable }:
    let
      inherit (builtins) attrNames attrValues readDir;
      inherit (nixpkgs) lib;
      inherit (lib) removeSuffix;
      inherit (utils) pathsToImportedAttrs;

      utils = import ./lib/utils.nix { inherit lib; };

      system = "x86_64-linux";

      pkgImport = pkgs:
        import pkgs {
          inherit system;
          overlays = attrValues self.overlays;
          config = { allowUnfree = true; };
        };

      pkgs = pkgImport nixpkgs;
      unstablePkgs = pkgImport unstable;

    in {
      nixosConfigurations =
        import ./hosts (inputs // { inherit system pkgs unstablePkgs utils; });

      devShell."${system}" = import ./shell.nix { inherit pkgs; };

      overlay = import ./pkgs;

      overlays = let
        overlayDir = ./overlays;
        fullPath = name: overlayDir + "/${name}";
        overlayPaths = map fullPath (attrNames (readDir overlayDir));
      in pathsToImportedAttrs overlayPaths;

      packages."${system}" = self.overlay pkgs pkgs;

      nixosModules = let
        # binary cache
        cachix = import ./cachix.nix;
        cachixAttrs = { inherit cachix; };

        # modules
        moduleList = import ./modules/list.nix;
        modulesAttrs = pathsToImportedAttrs moduleList;

        # profiles
        profilesList = import ./profiles/list.nix;
        profilesAttrs = { profiles = pathsToImportedAttrs profilesList; };

      in cachixAttrs // modulesAttrs // profilesAttrs;
    };
}

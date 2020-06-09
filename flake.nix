{
  description = "A highly structured configuration database.";

  inputs.nixpkgs.url = "nixpkgs/release-20.03";
  inputs.home.url = "github:rycee/home-manager/bqv-flakes";

  outputs = inputs@{ self, home, nixpkgs }:
    let
      inherit (builtins) listToAttrs baseNameOf attrNames attrValues readDir;
      inherit (nixpkgs.lib) removeSuffix;
      system = "x86_64-linux";

      # Generate an attribute set by mapping a function over a list of values.
      genAttrs' = values: f: listToAttrs (map f values);

      # Convert a list to file paths to attribute set
      # that has the filenames stripped of nix extension as keys
      # and imported content of the file as value.
      pathsToImportedAttrs = paths:
        genAttrs' paths (path: {
          name = removeSuffix ".nix" (baseNameOf path);
          value = import path;
        });

      pkgs = import nixpkgs {
        inherit system;
        overlays = attrValues self.overlays;
        config = { allowUnfree = true; };
      };

    in {
      nixosConfigurations =
        let configs = import ./hosts (inputs // { inherit system pkgs; });
        in configs;

      overlay = import ./pkgs;

      overlays =
        let
          overlayDir = ./overlays;
          fullPath = name: overlayDir + "/${name}";
          overlayPaths = map fullPath (attrNames (readDir overlayDir));
        in pathsToImportedAttrs overlayPaths;

      packages.x86_64-linux = {
        inherit (pkgs) sddm-chili dejavu_nerdfont purs pure;
      };

      nixosModules = let
        # modules
        moduleList = import ./modules/list.nix;
        modulesAttrs = pathsToImportedAttrs moduleList;

        # profiles
        profilesList = import ./profiles/list.nix;
        profilesAttrs = { profiles = pathsToImportedAttrs profilesList; };

      in modulesAttrs // profilesAttrs;
    };
}

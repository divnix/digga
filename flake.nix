{
  description = "A highly structured configuration database.";

  inputs =
    {
      master.url = "nixpkgs/master";
      nixos.url = "nixpkgs/release-20.09";
      home.url = "github:nix-community/home-manager/release-20.09";
    };

  outputs = inputs@{ self, home, nixos, master }:
    let
      inherit (builtins) attrNames attrValues readDir;
      inherit (nixos) lib;
      inherit (lib) removeSuffix recursiveUpdate genAttrs filterAttrs;
      inherit (utils) pathsToImportedAttrs;

      utils = import ./lib/utils.nix { inherit lib; };

      system = "x86_64-linux";

      pkgImport = pkgs:
        import pkgs {
          inherit system;
          overlays = attrValues self.overlays;
          config = { allowUnfree = true; };
        };

      pkgset = {
        osPkgs = pkgImport nixos;
        pkgs = pkgImport master;
      };

    in
    with pkgset;
    {
      nixosConfigurations =
        import ./hosts (recursiveUpdate inputs {
          inherit lib pkgset system utils;
        }
        );

      devShell."${system}" = import ./shell.nix {
        inherit pkgs;
      };

      overlay = import ./pkgs;

      overlays =
        let
          overlayDir = ./overlays;
          fullPath = name: overlayDir + "/${name}";
          overlayPaths = map fullPath (attrNames (readDir overlayDir));
        in
        pathsToImportedAttrs overlayPaths;

      packages."${system}" =
        let
          packages = self.overlay osPkgs osPkgs;
          overlays = lib.filterAttrs (n: v: n != "pkgs") self.overlays;
          overlayPkgs =
            genAttrs
              (attrNames overlays)
              (name: (overlays."${name}" osPkgs osPkgs)."${name}");
        in
        recursiveUpdate packages overlayPkgs;

      nixosModules =
        let
          # binary cache
          cachix = import ./cachix.nix;
          cachixAttrs = { inherit cachix; };

          # modules
          moduleList = import ./modules/list.nix;
          modulesAttrs = pathsToImportedAttrs moduleList;

          # profiles
          profilesList = import ./profiles/list.nix;
          profilesAttrs = { profiles = pathsToImportedAttrs profilesList; };

        in
        recursiveUpdate
          (recursiveUpdate cachixAttrs modulesAttrs)
          profilesAttrs;

      templates.flk.path = ./.;
      templates.flk.description = "flk template";

      defaultTemplate = self.templates.flk;
    };
}

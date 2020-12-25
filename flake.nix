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
      inherit (utils) pathsToImportedAttrs genPkgset overlayPaths modules
        genPackages;

      utils = import ./lib/utils.nix { inherit lib; };

      system = "x86_64-linux";

      externOverlays = [ ];

      pkgset =
        let overlays = (attrValues self.overlays) ++ externOverlays; in
        genPkgset {
          inherit master nixos overlays system;
        };
    in
    with pkgset;
    {
      nixosConfigurations =
        import ./hosts (recursiveUpdate inputs {
          inherit lib pkgset system utils;
        });

      devShell."${system}" = import ./shell.nix {
        pkgs = osPkgs;
      };

      overlay = import ./pkgs;

      overlays = pathsToImportedAttrs overlayPaths;

      packages."${system}" = genPackages {
        overlay = self.overlay;
        overlays = self.overlays;
        pkgs = osPkgs;
      };

      nixosModules = modules;

      templates.flk.path = ./.;
      templates.flk.description = "flk template";

      defaultTemplate = self.templates.flk;
    };
}

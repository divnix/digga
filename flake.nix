{
  description = "A highly structured configuration database.";

  inputs =
    {
      master.url = "nixpkgs/master";
      nixos.url = "nixpkgs/release-20.09";
      home.url = "github:nix-community/home-manager/release-20.09";
      flake-utils.url = "github:numtide/flake-utils";
      devshell.url = "github:numtide/devshell";
    };

  outputs = inputs@{ self, home, nixos, master, flake-utils, nur, devshell }:
    let
      inherit (builtins) attrNames attrValues readDir elem pathExists filter;
      inherit (flake-utils.lib) eachDefaultSystem mkApp;
      inherit (nixos) lib;
      inherit (lib) all removeSuffix recursiveUpdate genAttrs filterAttrs
        mapAttrs;
      inherit (utils) pathsToImportedAttrs genPkgset overlayPaths modules
        genPackages pkgImport;

      utils = import ./lib/utils.nix { inherit lib; };

      system = "x86_64-linux";

      externOverlays = [ nur.overlay devshell.overlay ];
      externModules = [ home.nixosModules.home-manager ];

      pkgset =
        let overlays = (attrValues self.overlays) ++ externOverlays; in
        genPkgset {
          inherit master nixos overlays system;
        };

      outputs = {
        nixosConfigurations =
          import ./hosts (recursiveUpdate inputs {
            inherit lib pkgset system utils externModules;
          });

        overlay = import ./pkgs;

        overlays = pathsToImportedAttrs overlayPaths;

        nixosModules = modules;

        templates.flk.path = ./.;

        templates.flk.description = "flk template";

        defaultTemplate = self.templates.flk;
      };
    in
    (eachDefaultSystem
      (system':
        let
          pkgs' = pkgImport {
            pkgs = master;
            system = system';
            overlays = [ devshell.overlay ];
          };

          packages' = genPackages {
            overlay = self.overlay;
            overlays = self.overlays;
            pkgs = pkgs';
          };

          filtered = filterAttrs
            (_: v:
              (v.meta ? platforms)
              && (elem system' v.meta.platforms)
              && (
                (all (dev: dev.meta ? platforms) v.buildInputs)
                && (all (dev: elem system' dev.meta.platforms) v.buildInputs)
              ))
            packages';
        in
        {
          devShell = import ./shell.nix {
            pkgs = pkgs';
          };

          apps =
            let
              validApps = attrNames (filterAttrs (_: drv: pathExists "${drv}/bin")
                self.packages."${system}");

              validSystems = attrNames filtered;

              filterBins = filterAttrs
                (n: _: elem n validSystems && elem n validApps)
                filtered;
            in
            mapAttrs (_: drv: mkApp { inherit drv; }) filterBins;

          packages =
            filtered;
        })) // outputs;
}

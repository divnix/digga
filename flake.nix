{
  description = "A highly structured configuration database.";

  inputs =
    {
      master.url = "nixpkgs/master";
      nixos.url = "nixpkgs/release-20.09";
      home.url = "github:nix-community/home-manager/release-20.09";
      flake-utils.url = "github:numtide/flake-utils/flatten-tree-system";
      devshell.url = "github:numtide/devshell";
    };

  outputs = inputs@{ self, home, nixos, master, flake-utils, nur, devshell }:
    let
      inherit (builtins) attrNames attrValues elem pathExists;
      inherit (flake-utils.lib) eachDefaultSystem mkApp flattenTreeSystem;
      inherit (nixos) lib;
      inherit (lib) recursiveUpdate filterAttrs mapAttrs;
      inherit (utils) pathsToImportedAttrs genPkgset overlayPaths modules
        genPackages pkgImport devshells;

      utils = import ./lib/utils.nix { inherit lib; };

      externOverlays = [ nur.overlay devshell.overlay ];
      externModules = [ home.nixosModules.home-manager ];

      osSystem = "x86_64-linux";

      outputs =
        let
          system = osSystem;
          pkgset =
            let
              overlays =
                (attrValues self.overlays)
                ++ externOverlays
                ++ [ self.overlay ];
            in
            genPkgset {
              inherit master nixos overlays system;
            };
        in
        {
          nixosConfigurations =
            import ./hosts (recursiveUpdate inputs {
              inherit lib pkgset utils externModules system;
            });

          overlay = import ./pkgs;

          overlays = pathsToImportedAttrs overlayPaths;

          nixosModules = modules;

          devshellModules = devshells;

          templates.flk.path = ./.;

          templates.flk.description = "flk template";

          defaultTemplate = self.templates.flk;
        };
    in
    (eachDefaultSystem
      (system:
        let
          pkgs = pkgImport {
            inherit system;
            pkgs = master;
            overlays = [ devshell.overlay ];
          };

          packages = filterAttrs
            (_: drv: drv.meta.broken != true)
            (flattenTreeSystem system
              (genPackages {
                inherit self pkgs;
              })
            );


        in
        {
          inherit packages;

          devShell = import ./shell.nix {
            inherit pkgs;
          };

          apps =
            let
              validApps = attrNames (filterAttrs
                (_: drv:
                  drv.meta.broken != true
                  && pathExists "${drv}/bin"
                )
                self.packages."${osSystem}"
              );

              validSystems = attrNames packages;

              filterBins = filterAttrs
                (n: _: elem n validSystems && elem n validApps)
                packages;
            in
            mapAttrs (_: drv: mkApp { inherit drv; }) filterBins;

        })) // outputs;
}

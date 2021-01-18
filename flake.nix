{
  description = "A highly structured configuration database.";

  inputs =
    {
      # Once desired, bump master's locked revision:
      # nix flake update --update-input master
      master.url = "nixpkgs/master";
      nixos.url = "nixpkgs/release-20.09";
      home.url = "github:nix-community/home-manager/release-20.09";
      flake-utils.url = "github:numtide/flake-utils/flatten-tree-system";
      devshell.url = "github:numtide/devshell";
      nixos-hardware.url = "github:nixos/nixos-hardware";
    };

  outputs = inputs@{ self, home, nixos, master, flake-utils, nur, devshell, nixos-hardware }:
    let
      inherit (builtins) attrNames attrValues elem pathExists;
      inherit (flake-utils.lib) eachDefaultSystem mkApp flattenTreeSystem;
      inherit (nixos) lib;
      inherit (lib) recursiveUpdate filterAttrs mapAttrs;
      inherit (utils) pathsToImportedAttrs genPkgset overlayPaths modules
        genPackages pkgImport;

      utils = import ./lib/utils.nix { inherit lib; };

      externOverlays = [ nur.overlay devshell.overlay ];
      externModules = [ home.nixosModules.home-manager ];

      pkgs' = unstable:
        let
          override = import ./pkgs/override.nix;
          overlays = (attrValues self.overlays)
            ++ externOverlays
            ++ [ self.overlay (override unstable) ];
        in
        pkgImport nixos overlays;

      unstable' = pkgImport master [ ];

      osSystem = "x86_64-linux";

      outputs =
        let
          system = osSystem;
          unstablePkgs = unstable' system;
          osPkgs = pkgs' unstablePkgs system;
        in
        {
          nixosConfigurations =
            import ./hosts (recursiveUpdate inputs {
              inherit lib osPkgs unstablePkgs utils externModules system;
            });

          overlay = import ./pkgs;

          overlays = pathsToImportedAttrs overlayPaths;

          nixosModules = modules;

          templates.flk.path = ./.;

          templates.flk.description = "flk template";

          defaultTemplate = self.templates.flk;
        };
    in
    recursiveUpdate
      (eachDefaultSystem
        (system:
          let
            unstablePkgs = unstable' system;
            pkgs = pkgs' unstablePkgs system;

            packages = flattenTreeSystem system
              (genPackages {
                inherit self pkgs;
              });
          in
          {
            inherit packages;

            devShell = import ./shell.nix {
              inherit pkgs;
            };
          }
        )
      )
      outputs;
}

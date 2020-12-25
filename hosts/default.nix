{ home
, lib
, nixos
, master
, pkgset
, self
, system
, utils
, ...
}:
let
  inherit (utils) recImport;
  inherit (builtins) attrValues removeAttrs;
  inherit (pkgset) osPkgs unstablePkgs;

  config = hostName:
    lib.nixosSystem {
      inherit system;

      modules =
        let
          inherit (home.nixosModules) home-manager;

          core = self.nixosModules.profiles.core;

          global = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            networking.hostName = hostName;
            nix.nixPath = let path = toString ../.; in
              [
                "nixos-unstable=${master}"
                "nixpkgs=${nixos}"
                "nixos-config=${path}/configuration.nix"
                "nixpkgs-overlays=${path}/overlays"
                "home-manager=${home}"
              ];

            nixpkgs.pkgs = osPkgs;

            nix.registry = {
              master.flake = master;
              nixflk.flake = self;
              nixpkgs.flake = nixos;
              home-manager.flake = home;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

          overrides = {
            nixpkgs.overlays =
              let
                override = import ../pkgs/override.nix unstablePkgs;

                overlay = pkg: final: prev: {
                  "${pkg.pname}" = pkg;
                };
              in
              map overlay override;
          };

          local = import "${toString ./.}/${hostName}.nix";

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues (removeAttrs self.nixosModules [ "profiles" ]);

        in
        flakeModules ++ [ core global local home-manager overrides ];

      extraArgs = {
        inherit system;
      };
    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts

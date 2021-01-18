{ home
, lib
, nixos
, master
, osPkgs
, self
, system
, unstablePkgs
, utils
, externModules
, ...
}:
let
  inherit (utils) recImport;
  inherit (builtins) attrValues removeAttrs;

  unstableModules = [ ];
  addToDisabledModules = [ ];

  config = hostName:
    lib.nixosSystem {
      inherit system;

      specialArgs =
        {
          unstableModulesPath = "${master}/nixos/modules";
        };

      modules =
        let
          core = self.nixosModules.profiles.core;

          modOverrides = { config, unstableModulesPath, ... }: {
            disabledModules = unstableModules ++ addToDisabledModules;
            imports = map
              (path: "${unstableModulesPath}/${path}")
              unstableModules;
          };

          global = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            hardware.enableRedistributableFirmware = lib.mkDefault true;

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

          local = import "${toString ./.}/${hostName}.nix";

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues (removeAttrs self.nixosModules [ "profiles" ]);

        in
        flakeModules ++ [
          core
          global
          local
          modOverrides
        ] ++ externModules;

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts

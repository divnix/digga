{ extern
, home
, lib
, nixos
, nixos-hardware
, override
, pkgs
, self
, system
, ...
}:
let
  inherit (lib) dev;

  suites = import ../suites { inherit lib; };

  config = hostName:
    dev.nixosSystemExtended {
      inherit system;

      specialArgs = extern.specialArgs // { inherit suites; };

      modules =
        let
          core = ../profiles/core;

          modOverrides = { config, overrideModulesPath, ... }:
            let
              overrides = import ../overrides;
              inherit (overrides) modules disabledModules;
            in
            {
              disabledModules = modules ++ disabledModules;
              imports = map
                (path: "${overrideModulesPath}/${path}")
                modules;
            };

          global = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            hardware.enableRedistributableFirmware = lib.mkDefault true;

            networking.hostName = hostName;

            nix.nixPath = [
              "nixpkgs=${nixos}"
              "nixos-config=${self}/compat/nixos"
              "home-manager=${home}"
            ];

            nixpkgs = { inherit pkgs; };

            nix.registry = {
              devos.flake = self;
              nixos.flake = nixos;
              override.flake = override;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

          local = {
            require = [
              "${toString ./.}/${hostName}.nix"
            ];
          };

          # Everything in `./modules/list.nix`.
          flakeModules =
            builtins.attrValues self.nixosModules;

        in
        flakeModules ++ [
          core
          global
          local
          modOverrides
        ] ++ extern.modules;

    };

  hosts = dev.recImport {
    dir = ./.;
    _import = config;
  };
in
hosts

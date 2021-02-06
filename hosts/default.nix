{ lib
, nixos
, master
, nixos-hardware
, pkgs
, self
, system
, extern
, ...
}:
let
  inherit (lib.flk) recImport nixosSystemExtended defaultImports;
  inherit (builtins) attrValues removeAttrs;

  suites = import ../suites { inherit lib; };

  config = hostName:
    nixosSystemExtended {
      inherit system;

      specialArgs = extern.specialArgs // { inherit suites; };

      modules =
        let
          core = import ../profiles/core;

          modOverrides = { config, unstableModulesPath, ... }:
            let
              unstable = import ../unstable;
              inherit (unstable) modules disabledModules;
            in
            {
              disabledModules = modules ++ disabledModules;
              imports = map
                (path: "${unstableModulesPath}/${path}")
                modules;
            };

          global = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            hardware.enableRedistributableFirmware = lib.mkDefault true;

            networking.hostName = hostName;
            nix.nixPath = [
              "nixos-unstable=${master}"
              "nixos=${nixos}"
              "nixpkgs=${nixos}"
            ];

            nixpkgs = { inherit pkgs; };

            nix.registry = {
              master.flake = master;
              nixflk.flake = self;
              nixpkgs.flake = nixos;
            };

            system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          };

          local = {
            require = [
              (import "${toString ./.}/${hostName}.nix")
            ];
          };

          # Everything in `./modules/list.nix`.
          flakeModules =
            attrValues self.nixosModules;

        in
        flakeModules ++ [
          core
          global
          local
          modOverrides
        ] ++ extern.modules;

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts

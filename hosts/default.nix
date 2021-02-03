{ lib
, nixos
, master
, nixos-hardware
, pkgs
, self
, system
, externModules
, ...
}:
let
  inherit (lib.flk) recImport nixosSystemExtended defaultImports;
  inherit (builtins) attrValues removeAttrs;

  profiles = defaultImports (toString ../profiles);
  suites = import ../profiles/suites.nix { inherit lib profiles; };

  unstableModules = [ ];
  addToDisabledModules = [ ];

  config = hostName:
    nixosSystemExtended {
      inherit system;

      specialArgs =
        {
          inherit suites;
          unstableModulesPath = "${master}/nixos/modules";
          hardware = nixos-hardware.nixosModules;
        };

      modules =
        let
          core = profiles.core.default;

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
            nix.nixPath = [
              "nixos-unstable=${master}"
              "nixos=${nixos}"
              "nixpkgs=${nixos}"
            ];

            nixpkgs = { inherit pkgs; };

            nix.registry = {
              master.flake = master;
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
        ] ++ externModules;

    };

  hosts = recImport {
    dir = ./.;
    _import = config;
  };
in
hosts

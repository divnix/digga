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
  inherit (lib.flk) recImport nixosSystemExtended defaultImports;
  inherit (builtins) attrValues removeAttrs;

  suites = import ../suites { inherit lib; };

  config = hostName:
    nixosSystemExtended {
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

          global =
            let
              inherit (lock) nodes;

              lock = builtins.fromJSON (builtins.readFile ../flake.lock);
            in
            {
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
                flk.flake = self;

                nixos = {
                  exact = true;
                  from = {
                    id = "nixos";
                    type = "indirect";
                  };
                  to = {
                    inherit (nixos) lastModified narHash rev;

                    path = override.outPath;
                    type = "path";
                  };
                };
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

{ lib, dev, nixos, inputs, self, ... }:

{ dir, extern, suites, overrides, multiPkgs, ... }:
let
  defaultSystem = "x86_64-linux";

  experimentalFeatures = [
    "flakes"
    "nix-command"
    "ca-references"
    "ca-derivations"
  ];

  modules = {
    modOverrides = { config, overrideModulesPath, ... }:
      let
        inherit (overrides) modules disabledModules;
      in
      {
        disabledModules = modules ++ disabledModules;
        imports = map
          (path: "${overrideModulesPath}/${path}")
          modules;
      };

    global = { config, options, pkgs, ... }:
      with lib; lib.mkMerge [
        (optionalAttrs (options ? home-manager) {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = extern.userSpecialArgs // { suites = suites.user; };
            sharedModules = extern.userModules ++ (builtins.attrValues self.homeModules);
          };
        })
        (optionalAttrs (options ? hardware.enableRedistributableFirmware) {
          hardware.enableRedistributableFirmware = lib.mkDefault true;
        })
        (optionalAttrs (options ? users.mutableUsers) {
          users.mutableUsers = lib.mkDefault false;
        })
        (optionalAttrs (options ? nix.nixPath) {
          nix.nixPath = [
            "nixpkgs=${nixos}"
            "nixos-config=${self}/compat/nixos"
            "home-manager=${inputs.home}"
          ];
        })
        (optionalAttrs (options ? nix.registry) {
          nix.registry = {
            devos.flake = self;
            nixos.flake = nixos;
            override.flake = inputs.override;
          };
        })
        (optionalAttrs (options ? nix.package) {
          nix.package = pkgs.nixFlakes;
        })
        (optionalAttrs (options ? nix.extraOptions) {
          nix.extraOptions = ''
            experimental-features = ${lib.concatStringsSep " "
              experimentalFeatures
            }
          '';
        })
        (optionalAttrs (options ? nixpkgs.pkgs) {
          nixpkgs.pkgs = lib.mkDefault multiPkgs.${config.nixpkgs.system};
        })
        (optionalAttrs (options ? system.configurationRevision) {
          system.configurationRevision = lib.mkIf (self ? rev) self.rev;
        })
      ];

    # Everything in `./modules/list.nix`.
    flakeModules = { imports = builtins.attrValues self.nixosModules ++ extern.modules; };

    cachix = ../../cachix.nix;
  };

  specialArgs = extern.specialArgs // { suites = suites.system; };

  mkHostConfig = hostName:
    let
      local = {
        require = [
          "${dir}/${hostName}.nix"
        ];

        networking = { inherit hostName; };

        _module.args = {
          inherit self;
          hosts = builtins.mapAttrs (_: host: host.config)
            (removeAttrs hosts [ hostName ]);
        };
      };
      lib = {
        lib = { inherit specialArgs; };
        lib.testModule = {
          imports = builtins.attrValues modules;
        };
      };
    in
    dev.os.devosSystem {
      inherit specialArgs;
      system = defaultSystem;
      modules = modules // { inherit local lib; };
    };

  hosts = dev.os.recImport
    {
      inherit dir;
      _import = mkHostConfig;
    };
in
hosts

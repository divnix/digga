{ extern
, home
, lib
, nixos
, override
, multiPkgs
, self
, defaultSystem
, ...
}:
let
  inherit (lib) dev;

  suites = import ../suites { inherit lib; };

  experimentalFeatures = [
    "flakes"
    "nix-command"
    "ca-references"
    "ca-derivations"
  ];

  modules = {
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

    global = { config, ... }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      hardware.enableRedistributableFirmware = lib.mkDefault true;

      nix.nixPath = [
        "nixpkgs=${nixos}"
        "nixos-config=${self}/compat/nixos"
        "home-manager=${home}"
      ];

      nixpkgs.pkgs = lib.mkDefault multiPkgs.${config.nixpkgs.system};

      nix.registry = {
        devos.flake = self;
        nixos.flake = nixos;
        override.flake = override;
      };

      nix.extraOptions = ''
        experimental-features = ${lib.concatStringsSep " "
          experimentalFeatures
        }
      '';

      system.configurationRevision = lib.mkIf (self ? rev) self.rev;
    };

    # Everything in `./modules/list.nix`.
    flakeModules = { imports = builtins.attrValues self.nixosModules ++ extern.modules; };
  };

  specialArgs = extern.specialArgs // { inherit suites; };

  mkHostConfig = hostName:
    let
      local = {
        require = [
          "${toString ./.}/${hostName}.nix"
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
      dir = ./.;
      _import = mkHostConfig;
    };
in
hosts

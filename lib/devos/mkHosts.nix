{ lib  }:

{ userFlakeNixOS, userFlakeInputs, userFlakeSelf }:

{ dir, extern, suites, overrides, multiPkgs }:
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

    global = { config, pkgs, ... }: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        extraSpecialArgs = extern.userSpecialArgs // { suites = suites.user; };
        sharedModules = extern.userModules ++ (builtins.attrValues userFlakeSelf.homeModules);
      };
      users.mutableUsers = lib.mkDefault false;

      hardware.enableRedistributableFirmware = lib.mkDefault true;

      nix.nixPath = [
        "nixpkgs=${userFlakeNixOS}"
        "nixos-config=${userFlakeSelf}/compat/nixos"
        "home-manager=${userFlakeInputs.home}"
      ];

      nixpkgs.pkgs = lib.mkDefault multiPkgs.${config.nixpkgs.system};

      nix.registry = {
        devos.flake = userFlakeSelf;
        nixos.flake = userFlakeNixOS;
        override.flake = userFlakeInputs.override;
      };

      nix.package = pkgs.nixFlakes;

      nix.extraOptions = ''
        experimental-features = ${lib.concatStringsSep " "
          experimentalFeatures
        }
      '';

      system.configurationRevision = lib.mkIf (userFlakeSelf ? rev) userFlakeSelf.rev;
    };

    # Everything in `./modules/list.nix`.
    flakeModules = { imports = builtins.attrValues userFlakeSelf.nixosModules ++ extern.modules; };

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
          self = userFlakeSelf;
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
    lib.os.devosSystem {
      inherit userFlakeNixOS userFlakeInputs userFlakeSelf;
    } {
      inherit specialArgs;
      system = defaultSystem;
      modules = modules // { inherit local lib; };
    };

  hosts = lib.os.recImport
    {
      inherit dir;
      _import = mkHostConfig;
    };
in
hosts

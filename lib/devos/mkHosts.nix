{ lib }:

{ self, nixos, inputs, dir, extern, suites, overrides, multiPkgs }:
let
  defaultSystem = "x86_64-linux";

  modules = with lib.modules; {
    modOverrides = modOverrides { inherit overrides; };
    hmDefaults = hmDefaults {
      inherit extern;
      inherit (self) homeModules;
      userSuites = suites.user;
    };
    globalDefaults = globalDefaults {
      inherit self nixos inputs multiPkgs;
    };
    cachix = cachix { inherit self; };
    flakeModules = flakeModules { inherit self extern; };
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
          self = self;
          hosts = builtins.mapAttrs (_: host: host.config)
            (removeAttrs hosts [ hostName ]);
        };

        lib = { inherit specialArgs; };
        lib.testModule = {
          imports = builtins.attrValues modules;
        };

      };
    in
    lib.os.devosSystem {
      inherit self nixos inputs specialArgs;
      system = defaultSystem;
      modules = modules // { inherit local; };
    };

  hosts = lib.os.recImport
    {
      inherit dir;
      _import = mkHostConfig;
    };
in
hosts

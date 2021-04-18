{ lib, inputs, ... }:
let
  inherit (dev) os;
  inherit (inputs) utils deploy;
in

_: { self, ... } @ args:
let

  userSelf = self;

  cfg = (lib.mkFlake.evalOldArgs { inherit args; }).config;

  multiPkgs = os.mkPkgs { inherit (cfg) extern overrides; };

  outputs = {
    nixosConfigurations = os.mkHosts {
      inherit userSelf multiPkgs;
      inherit (cfg) extern suites overrides;
      dir = cfg.hosts;
    };

    homeConfigurations = os.mkHomeConfigurations;

    nixosModules = cfg.modules;

    homeModules = cfg.userModules;

    overlay = cfg.packages;
    inherit (cfg) overlays;

    deploy.nodes = os.mkNodes deploy userSelf.nixosConfigurations;
  };

  systemOutputs = utils.lib.eachDefaultSystem (system:
    let
      pkgs = multiPkgs.${system};
      pkgs-lib = lib.pkgs-lib.${system};
      # all packages that are defined in ./pkgs
      legacyPackages = os.mkPackages { inherit pkgs; };
    in
    {
      checks = pkgs-lib.tests.mkChecks {
        inherit (userSelf.deploy) nodes;
        hosts = userSelf.nixosConfigurations;
        homes = userSelf.homeConfigurations;
      };

      inherit legacyPackages;
      packages = lib.filterPackages system legacyPackages;

      devShell = pkgs-lib.shell;
    });
in
outputs // systemOutputs


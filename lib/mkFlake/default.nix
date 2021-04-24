{ lib, deploy }:
let
  inherit (lib) os;
in

_: { self, inputs, nixos, ... } @ args:
let

  cfg = (
    lib.mkFlake.evalOldArgs
      { inherit self inputs args; }
  ).config;

  multiPkgs = os.mkPkgs
    {
      inherit self inputs nixos;
      inherit (cfg) extern overrides;
    };

  outputs = {
    nixosConfigurations = os.mkHosts
      {
        inherit self inputs nixos multiPkgs;
        inherit (cfg) extern suites overrides;
        dir = cfg.hosts;
      };

    homeConfigurations = os.mkHomeConfigurations self.nixosConfigurations;

    nixosModules = cfg.modules;

    homeModules = cfg.userModules;

    overlay = cfg.packages;
    inherit (cfg) overlays;

    deploy.nodes = os.mkNodes deploy self.nixosConfigurations;
  };

  systemOutputs = lib.eachDefaultSystem (system:
    let
      pkgs = multiPkgs.${system};
      pkgs-lib = lib.pkgs-lib.${system};
      # all packages that are defined in ./pkgs
      legacyPackages = os.mkPackages {
        inherit pkgs;
        inherit (self) overlay overlays;
      };
    in
    {
      checks = pkgs-lib.tests.mkChecks {
        inherit (self.deploy) nodes;
        hosts = self.nixosConfigurations;
        homes = self.homeConfigurations;
      };

      inherit legacyPackages;
      packages = lib.filterPackages system legacyPackages;

      devShell = pkgs-lib.shell;
    });
in
outputs // systemOutputs


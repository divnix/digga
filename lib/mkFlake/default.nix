{ dev, nixos, inputs, ... }:
let
  inherit (dev) os;
  inherit (inputs) utils deploy;
  evalFlakeArgs = dev.callLibs ./evalArgs.nix;
in

{ self, ... } @ args:
let

  cfg = (evalFlakeArgs { inherit args; }).config;

  multiPkgs = os.mkPkgs {
    inherit (cfg) extern overrides;
    inherit (self) overlay overlays;
  };

  outputs = {
    nixosConfigurations = os.mkHosts {
      inherit self multiPkgs;
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

  systemOutputs = utils.lib.eachDefaultSystem (system:
    let
      pkgs = multiPkgs.${system};
      pkgs-lib = dev.pkgs-lib.${system};
      # all packages that are defined in ./pkgs
      legacyPackages = os.mkPackages {
        inherit (self) overlay overlays;
        inherit pkgs;
      };
    in
    {
      checks = pkgs-lib.tests.mkChecks {
        inherit (self.deploy) nodes;
        hosts = self.nixosConfigurations;
        homes = self.homeConfigurations;
      };

      inherit legacyPackages;
      packages = dev.filterPackages system legacyPackages;

      devShell = pkgs-lib.shell;
    });
in
outputs // systemOutputs


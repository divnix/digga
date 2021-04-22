{ lib, deploy }:
let
  inherit (lib) os;
in

_: { self, inputs, nixos, ... } @ args:
let

  userFlakeSelf = self;
  userFlakeInputs = inputs;
  userFlakeNixOS = nixos;

  cfg = (
    lib.mkFlake.evalOldArgs
      { inherit userFlakeSelf userFlakeInputs; }
      { inherit args; }
  ).config;

  multiPkgs = os.mkPkgs
    { inherit userFlakeSelf userFlakeInputs userFlakeNixOS; }
    { inherit (cfg) extern overrides; };

  outputs = {
    nixosConfigurations = os.mkHosts
      { inherit userFlakeSelf userFlakeInputs userFlakeNixOS; }
      {
        inherit multiPkgs;
        inherit (cfg) extern suites overrides;
        dir = cfg.hosts;
      };

    homeConfigurations = os.mkHomeConfigurations
      { inherit userFlakeSelf; };

    nixosModules = cfg.modules;

    homeModules = cfg.userModules;

    overlay = cfg.packages;
    inherit (cfg) overlays;

    deploy.nodes = os.mkNodes deploy userFlakeSelf.nixosConfigurations;
  };

  systemOutputs = lib.eachDefaultSystem (system:
    let
      pkgs = multiPkgs.${system};
      pkgs-lib = lib.pkgs-lib.${system};
      # all packages that are defined in ./pkgs
      legacyPackages = os.mkPackages
        { inherit userFlakeSelf; }
        { inherit pkgs; };
    in
    {
      checks = pkgs-lib.tests.mkChecks {
        inherit (userFlakeSelf.deploy) nodes;
        hosts = userFlakeSelf.nixosConfigurations;
        homes = userFlakeSelf.homeConfigurations;
      };

      inherit legacyPackages;
      packages = lib.filterPackages system legacyPackages;

      devShell = pkgs-lib.shell;
    });
in
outputs // systemOutputs


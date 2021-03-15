{
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/release-20.09";
      override.url = "nixpkgs";
      ci-agent = {
        url = "github:hercules-ci/hercules-ci-agent";
        inputs = { nix-darwin.follows = "darwin"; flake-compat.follows = "flake-compat"; nixos-20_09.follows = "nixos"; nixos-unstable.follows = "override"; };
      };
      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "override";
      deploy = {
        url = "github:serokell/deploy-rs";
        inputs = { flake-compat.follows = "flake-compat"; naersk.follows = "naersk"; nixpkgs.follows = "override"; utils.follows = "utils"; };
      };
      devshell.url = "github:numtide/devshell";
      flake-compat.url = "github:BBBSnowball/flake-compat/pr-1";
      flake-compat.flake = false;
      home.url = "github:nix-community/home-manager/release-20.09";
      home.inputs.nixpkgs.follows = "nixos";
      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "override";
      nix.inputs.nixpkgs.follows = "nixos";
      nixos-hardware.url = "github:nixos/nixos-hardware";
      utils.url = "github:numtide/flake-utils/flatten-tree-system";
      pkgs.url = "path:./pkgs";
      pkgs.inputs.nixpkgs.follows = "nixos";
    };

  outputs = inputs@{ deploy, nixos, nur, nix, self, utils, ... }:
    let
      inherit (self) lib;
      inherit (lib) os;

      extern = import ./extern { inherit inputs; };

      pkgs' = os.mkPkgs { inherit self; };

      outputs =
        let
          system = "x86_64-linux";
          pkgs = pkgs'.${system};
        in
        {
          nixosConfigurations =
            import ./hosts (nixos.lib.recursiveUpdate inputs {
              inherit pkgs system extern;
              inherit (pkgs) lib;
            });

          nixosModules =
            let moduleList = import ./modules/module-list.nix;
            in lib.pathsToImportedAttrs moduleList;

          overlay = import ./pkgs;
          overlays = lib.pathsToImportedAttrs (lib.pathsIn ./overlays);

          lib = import ./lib { inherit nixos pkgs; };

          templates.flk.path = ./.;
          templates.flk.description = "flk template";
          defaultTemplate = self.templates.flk;

          deploy.nodes = os.mkNodes deploy self.nixosConfigurations;

          checks =
            let
              tests = import ./tests { inherit self pkgs; };
              deployChecks = builtins.mapAttrs
                (system: deployLib: deployLib.deployChecks self.deploy)
                deploy.lib;
            in
            nixos.lib.recursiveUpdate tests deployChecks;
        };

      systemOutputs = utils.lib.eachDefaultSystem (system:
        let pkgs = pkgs'.${system}; in
        {
          packages = utils.lib.flattenTreeSystem system
            (os.mkPackages {
              inherit self pkgs;
            });

          devShell = import ./shell {
            inherit self system;
          };

          legacyPackages.hmActivationPackages =
            os.mkHomeActivation { inherit self; };
        }
      );
    in
    nixos.lib.recursiveUpdate outputs systemOutputs;
}

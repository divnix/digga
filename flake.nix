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
      nixos-hardware.url = "github:nixos/nixos-hardware";
      utils.url = "github:numtide/flake-utils/flatten-tree-system";
      srcs.url = "path:./pkgs";
    };

  outputs =
    inputs@{ ci-agent
    , deploy
    , devshell
    , home
    , nixos
    , nixos-hardware
    , nur
    , override
    , self
    , utils
    , ...
    }:
    let
      inherit (utils.lib) eachDefaultSystem flattenTreeSystem;
      inherit (nixos.lib) recursiveUpdate;
      inherit (self.lib) overlays nixosModules genPackages genPkgs
        genHomeActivationPackages mkNodes;

      extern = import ./extern { inherit inputs; };

      pkgs' = genPkgs { inherit self; };

      outputs =
        let
          system = "x86_64-linux";
          pkgs = pkgs'.${system};
        in
        {
          inherit nixosModules overlays;

          nixosConfigurations =
            import ./hosts (recursiveUpdate inputs {
              inherit pkgs system extern;
              inherit (pkgs) lib;
            });

          overlay = import ./pkgs;

          lib = import ./lib { inherit nixos pkgs; };

          templates.flk.path = ./.;

          templates.flk.description = "flk template";

          defaultTemplate = self.templates.flk;

          deploy.nodes = mkNodes deploy self.nixosConfigurations;

          checks = builtins.mapAttrs
            (system: deployLib: deployLib.deployChecks self.deploy)
            deploy.lib;
        };

      systemOutputs = eachDefaultSystem (system:
        let pkgs = pkgs'.${system}; in
        {
          packages = flattenTreeSystem system
            (genPackages {
              inherit self pkgs;
            });

          devShell = import ./shell {
            inherit self system;
          };

          legacyPackages.hmActivationPackages =
            genHomeActivationPackages { inherit self; };
        }
      );
    in
    recursiveUpdate outputs systemOutputs;
}

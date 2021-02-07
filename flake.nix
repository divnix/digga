{
  description = "A highly structured configuration database.";

  inputs =
    {
      # Once desired, bump master's locked revision:
      # nix flake update --update-input master
      master.url = "nixpkgs/master";
      nixos.url = "nixpkgs/release-20.09";
      home.url = "github:nix-community/home-manager/release-20.09";
      home.inputs.nixpkgs.follows = "nixos";
      flake-utils.url = "github:numtide/flake-utils/flatten-tree-system";
      devshell.url = "github:numtide/devshell";
      nixos-hardware.url = "github:nixos/nixos-hardware";
      ci-agent.url = "github:hercules-ci/hercules-ci-agent";
      ci-agent.inputs.nixos-20_09.follows = "nixos";
      ci-agent.inputs.nixos-unstable.follows = "master";
    };

  outputs =
    inputs@{ self
    , ci-agent
    , home
    , nixos
    , master
    , flake-utils
    , nur
    , devshell
    , nixos-hardware
    }:
    let
      inherit (flake-utils.lib) eachDefaultSystem flattenTreeSystem;
      inherit (nixos.lib) recursiveUpdate;
      inherit (self.lib) overlays nixosModules genPackages genPkgs
        genHomeActivationPackages;

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

          lib = import ./lib { inherit nixos; };

          templates.flk.path = ./.;

          templates.flk.description = "flk template";

          defaultTemplate = self.templates.flk;
        };

      systemOutputs = eachDefaultSystem (system:
        let pkgs = pkgs'.${system}; in
        {
          packages = flattenTreeSystem system
            (genPackages {
              inherit self pkgs;
            });

          devShell = import ./shell {
            inherit pkgs nixos;
          };

          legacyPackages.hmActivationPackages =
            genHomeActivationPackages { inherit self; };
        }
      );
    in
    recursiveUpdate outputs systemOutputs;
}

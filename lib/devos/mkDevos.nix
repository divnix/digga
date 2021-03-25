{ self, nixos, inputs, ... }:
let
  devos = self;
in

{ self, ... } @ args:
let
  inherit (self) lib;
  inherit (lib) os;

  inherit (inputs) utils deploy;

  cfg = (os.evalDevosArgs { inherit args; }).config;

  multiPkgs = os.mkPkgs { inherit (cfg) extern overrides; };

  outputs = {
    nixosConfigurations = os.mkHosts {
      inherit multiPkgs;
      inherit (cfg) extern suites overrides;
      dir = cfg.hosts;
    };

    homeConfigurations = os.mkHomeConfigurations;

    nixosModules = cfg.modules;

    homeModules = cfg.userModules;

    overlay = cfg.packages;
    inherit (cfg) overlays;

    lib = import "${devos}/lib" { inherit self nixos inputs; };

    defaultTemplate = self.templates.flk;
    templates.flk.path = builtins.toPath self;
    templates.flk.description = "flk template";
    templates.mkdevos.path =
      let
        excludes = [ "lib" "tests" "cachix" "nix" "theme" ".github" "bors.toml" "cachix.nix" ];
        filter = path: type: ! builtins.elem (baseNameOf path) excludes;
      in
        builtins.filterSource filter ../..;
    templates.mkdevos.description = "for mkDevos usage";

    deploy.nodes = os.mkNodes deploy self.nixosConfigurations;
  };

  systemOutputs = utils.lib.eachDefaultSystem (system:
    let pkgs = multiPkgs.${system}; in
    {
      checks =
        let
          tests = nixos.lib.optionalAttrs (system == "x86_64-linux")
            (import "${devos}/tests" { inherit self pkgs; });
          deployHosts = nixos.lib.filterAttrs
            (n: _: self.nixosConfigurations.${n}.config.nixpkgs.system == system) self.deploy.nodes;
          deployChecks = deploy.lib.${system}.deployChecks { nodes = deployHosts; };
        in
        nixos.lib.recursiveUpdate tests deployChecks;

      packages = utils.lib.flattenTreeSystem system
        (os.mkPackages { inherit pkgs; })
        // { devosOptionsDoc = cfg.genDoc pkgs; };

      devShell = import "${devos}/shell" {
        inherit self pkgs system;
      };
    });
in
 nixos.lib.recursiveUpdate outputs systemOutputs


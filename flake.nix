{
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-unstable";
      override.url = "nixpkgs";
      devos.url = "path:./lib"; # TODO: outfactor into separate repo
      devos.inputs = {
        nixpkgs.follows = "nixos";
        # deploy.inputs = {
        #   flake-compat.follows = "flake-compat";
        #   naersk.follows = "naersk";
        #   nixpkgs.follows = "nixos";
        # };
      };

      ci-agent = {
        url = "github:hercules-ci/hercules-ci-agent";
        inputs = { nix-darwin.follows = "darwin"; flake-compat.follows = "flake-compat"; nixos-20_09.follows = "nixos"; nixos-unstable.follows = "override"; };
      };
      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "override";
      flake-compat.url = "github:BBBSnowball/flake-compat/pr-1";
      flake-compat.flake = false;
      home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";
      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "override";
      nixos-hardware.url = "github:nixos/nixos-hardware";

      pkgs.url = "path:./pkgs";
      pkgs.inputs.nixpkgs.follows = "nixos";
    };

  outputs = inputs@{ self, devos, nixos, nur, ... }:
    devos.lib.mkFlake {
      inherit self inputs nixos;
      hosts = ./hosts;
      packages = import ./pkgs;
      suites = import ./suites;
      extern = import ./extern;
      overrides = import ./overrides;
      overlays = ./overlays;
      profiles = ./profiles;
      userProfiles = ./users/profiles;
      modules = import ./modules/module-list.nix;
      userModules = import ./users/modules/module-list.nix;
    } // {
    defaultTemplate = self.templates.flk;
    templates.flk.path = ./.;
    templates.flk.description = "flk template";
  };
}

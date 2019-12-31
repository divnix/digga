{
  description = "A highly structured configuration database.";

  epoch = 201909;

  inputs.nixpkgs.url = "github:nrdxp/nixpkgs/fork";
  inputs.home.url = "github:nrdxp/home-manager/flakes";

  outputs = { self, home, nixpkgs }: {
    nixosConfigurations = let
      configs = import ./hosts {
        inherit nixpkgs;
        flake = self;
        home = home.nixosModules.home-manager;
      };

    in
      configs;

    overlays = let
      pkgs = import ./pkgs;
    in
      [ pkgs ];
  };

}

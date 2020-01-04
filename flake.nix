{
  description = "A highly structured configuration database.";

  epoch = 201909;

  inputs.nixpkgs.url = "github:nrdxp/nixpkgs/fork";
  inputs.home.url = "github:nrdxp/home-manager/flakes";

  outputs = args@{ self, home, nixpkgs }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = self.overlays;
    };
  in
    {
      nixosConfigurations = let
        configs = import ./hosts args;

      in
        configs;

      overlay = import ./pkgs;

      overlays = [ self.overlay ];

      packages.x86_64-linux = {
        inherit (pkgs) sddm-chili dejavu_nerdfont purs;
      };

      nixosModules = import ./modules;
    };
}

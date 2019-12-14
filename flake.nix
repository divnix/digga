{
  description = "A highly structured configuration database.";

  epoch = 201909;

  outputs = { self, nixpkgs, nix }: {
    nixosConfigurations =
      let
        configs = import ./configurations {
          inherit nix nixpkgs;
          flake = self;
          utils = import ./lib/utils.nix { lib = nixpkgs.lib; };
        };

      in
        configs;

  };

}

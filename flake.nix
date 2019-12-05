{
  description = "DevOS";

  epoch = 201909;

  outputs = { self, nixpkgs, nix }: {
    nixosConfigurations =
      let
        configs = import ./configurations {
          inherit nix nixpkgs;
          flake = self;
        };

      in
        configs;

  };

}

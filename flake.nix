{
  description = "A highly structured configuration database.";

  epoch = 201909;

  inputs.nixpkgs.url = "github:nrdxp/nixpkgs/fork";
  inputs.home.url = "github:nrdxp/home-manager/flakes";

  outputs = args@{ self, home, nixpkgs }:
    let
      inherit (builtins) listToAttrs baseNameOf;
      inherit (nixpkgs.lib) removeSuffix;

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = self.overlays;
      };
    in {
      nixosConfigurations =
        let configs = import ./hosts ({ lib = pkgs.lib; } // args);
        in configs;

      overlay = import ./pkgs;

      overlays = [ self.overlay ];

      packages.x86_64-linux = {
        inherit (pkgs) sddm-chili dejavu_nerdfont purs;
      };

      nixosModules = let
        prep = map (path: {
          name = removeSuffix ".nix" (baseNameOf path);
          value = import path;
        });

        moduleList = import ./modules;

        modulesAttrs = listToAttrs (prep moduleList);

        profilesList = import ./profiles;

        profilesAttrs = { profiles = listToAttrs (prep profilesList); };
      in modulesAttrs // profilesAttrs;
    };
}

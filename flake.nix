{
  epoch = 201909;
  description = "NixOS Configuration";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.gaze12 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        {
          system.configurationRevision = self.rev;
        }
      ];
    };
  };
}

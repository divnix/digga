{
  description = "Digga Library Jobs";
  inputs = {
    digga.url = "path:../";
    digga.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs @ { self, nixpkgs, digga }: {

    jobs.x86_64-linux = import ./. {
      inherit inputs;
      system = "x86_64-linux";
    };

  };
}

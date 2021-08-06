{
  description = "A DevOS example. And also a digga test bed.";

  inputs =
    {
      nixos.url = "github:nixos/nixpkgs/release-21.05";
      digga = {
        url = "path:../../";
        inputs.nixpkgs.follows = "nixos";
      };
      home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";
    };

  outputs = inputs @ { self, nixos, digga, home }:
    digga.lib.mkFlake {

      inherit self inputs;

      channels.nixos = { };

      nixos = ./nixos;
      home = ./home;
      devshell = ./devshell;

    };
}

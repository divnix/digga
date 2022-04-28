{
  description = "A DevOS example. And also a digga test bed.";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-21.11";
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.home-manager.follows = "home";
    home.url = "github:nix-community/home-manager/release-21.11";
    home.inputs.nixpkgs.follows = "nixos";
  };

  outputs = inputs @ { self, nixos, digga, home }:
    digga.lib.mkFlake {

      inherit self inputs;

      channels.nixos = { };

      nixos.hostDefaults.channelName = "nixos";

      home = ./home;

    };
}

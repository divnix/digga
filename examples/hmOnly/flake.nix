{
  description = "A DevOS example. And also a digga test bed.";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-22.05";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.home-manager.follows = "home";

    # FIXME: use 22.11 release
    home.url = "github:nix-community/home-manager";
    # home.url = "github:nix-community/home-manager/release-22.11";
    home.inputs.nixpkgs.follows = "nixos";
  };

  outputs = inputs @ {
    self,
    nixos,
    digga,
    home,
  }:
    digga.lib.mkFlake {
      inherit self inputs;

      channels.nixos = {};

      nixos.hostDefaults.channelName = "nixos";

      home = ./home;
    };
}

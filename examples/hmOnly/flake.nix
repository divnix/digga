{
  description = "Example tracking unstable channels and libraries";

  inputs = {
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-trunk.url = "github:NixOS/nixpkgs";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.05";

    digga.url = "github:divnix/digga/home-manager-22.11";
    digga.inputs.nixpkgs.follows = "nixpkgs";
    digga.inputs.nixlib.follows = "nixpkgs";
    digga.inputs.home-manager.follows = "home-manager";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixos-unstable";

    nixpkgs.follows = "nixos-unstable";
  };

  outputs = {
    self
    , digga
    , nixos-unstable
    , home-manager
    , nixpkgs
    , ...
  } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      channels = {
        nixos-unstable = {};
        nixos-stable = {};
        nixos-trunk = {};
      };


      # FIXME: should probably not be required, but it is.
      nixos.hostDefaults.channelName = "nixos";

      home = ./home;

    };
}

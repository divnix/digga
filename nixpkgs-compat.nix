let
  inherit (builtins)
    fetchTarball
    fromJSON
    readFile
    ;
  nixos = (fromJSON (readFile ./flake.lock)).nodes.nixos.locked;
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${nixos.rev}.tar.gz";
    sha256 = nixos.narHash;
  };
in
nixpkgs

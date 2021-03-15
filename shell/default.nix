{ self ? (import ../compat).defaultNix
, system ? builtins.currentSystem
}:
let
  pkgs = (self.lib.os.mkPkgs { inherit self; }).${system};

  inherit (pkgs) lib;

  installPkgs = (lib.nixosSystem {
    inherit system;
    modules = [ ];
  }).config.system.build;

  flk = pkgs.callPackage ./flk.nix { };

in
pkgs.devshell.mkShell
{
  imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];

  packages = with installPkgs; [
    nixos-install
    nixos-generate-config
    nixos-enter
    pkgs.nixFlakes
  ];

  git.hooks = {
    pre-commit.text = lib.fileContents ./pre-commit.sh;
  };

  commands = with pkgs; [
    {
      package = flk;
    }
  ]
  ++ lib.optional (system != "i686-linux") { package = cachix; }
  ++ lib.optional (system == "x86_64-linux") {
    name = "deploy";
    package = deploy-rs;
    help = "A simple multi-profile Nix-flake deploy tool.";
  };
}

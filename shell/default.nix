{ self ? (import ../compat).defaultNix
, system ? builtins.currentSystem
}:
let
  pkgs = (self.lib.genPkgs { inherit self; }).${system};

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
  ] ++ lib.optional (system == "x86_64-linux") pkgs.deploy-rs;

  git.hooks = {
    pre-commit.text = lib.fileContents ./pre-commit.sh;
  };

  commands = with pkgs; [
    {
      package = flk;
    }
    {
      name = "nix";
      help = nixFlakes.meta.description;
      command = ''
        ${nixFlakes}/bin/nix --option experimental-features \
          "nix-command flakes ca-references" "$@"
      '';
    }
  ] ++ lib.optional (system != "i686-linux") { package = cachix; };
}

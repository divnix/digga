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

  inherit (flk) name;
in
pkgs.devshell.mkShell {
  inherit name;

  packages = with pkgs; with installPkgs; [
    git-crypt
    nixos-install
    nixos-generate-config
    nixos-enter
    mdbook
  ];

  env = { inherit name; };

  git.hooks = {
    enable = true;
    pre-commit.text = lib.fileContents ./pre-commit.sh;
  };

  commands = with pkgs; let
    mkCommand = category: package: {
      inherit package category;
      name = package.pname or package.name;
      help = package.meta.description;
    };

    mapCmd = category: map (mkCommand category);
  in
  mapCmd "main"
    (
      [ flk git ] ++
      lib.optional (system != "i686-linux") cachix
    ) ++
  mapCmd "linters" [ nixpkgs-fmt editorconfig-checker ] ++
  mapCmd "documentation" [ python3Packages.grip mdbook ] ++ [
    {
      name = "nix";
      help = nixFlakes.meta.description;
      category = "main";
      command = ''
        ${nixFlakes}/bin/nix --option experimental-features \
          "nix-command flakes ca-references" "$@"
      '';
    }
  ];

}

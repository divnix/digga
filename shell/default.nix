{ pkgs ? (import ./compat).defaultNix.legacyPackages."${builtins.currentSystem}"
, nixos ? (import ./compat).defaultNix.inputs.nixos
, ...
}:
let
  build = "config.system.build";

  installPkgs = (import "${nixos}/nixos" {
    configuration = { };
    system = pkgs.system;
  }).config.system.build;

  flk = pkgs.writeShellScriptBin "flk" ''
    if [[ -z "$1" ]]; then
      echo "Usage: $(basename "$0") [ iso | up | install {host} | {host} [switch|boot|test] ]"
    elif [[ "$1" == "up" ]]; then
      mkdir -p $DEVSHELL_ROOT/up
      hostname=$(hostname)
      nixos-generate-config --dir $DEVSHELL_ROOT/up/$hostname
      echo \
      "{
      imports = [ ../up/$hostname/configuration.nix ];
    }" > $DEVSHELL_ROOT/hosts/up-$hostname.nix
    git add -f $DEVSHELL_ROOT/up/$hostname
    git add -f $DEVSHELL_ROOT/hosts/up-$hostname.nix
    elif [[ "$1" == "iso" ]]; then
      nix build $DEVSHELL_ROOT#nixosConfigurations.niximg.${build}.isoImage "${"\${@:2}"}"
    elif [[ "$1" == "install" ]]; then
      sudo nixos-install --flake "$DEVSHELL_ROOT#$2" "${"\${@:3}"}"
    else
      sudo nixos-rebuild --flake "$DEVSHELL_ROOT#$1" "${"\${@:2}"}"
    fi
  '';

  name = "flk";
in
pkgs.mkDevShell {
  inherit name;

  packages = with pkgs; with installPkgs; [
    git-crypt
    nixos-install
    nixos-generate-config
    nixos-enter
    nixos-option
    pre-commit
  ];

  env = { inherit name; };

  commands = with pkgs; [
    {
      name = nixpkgs-fmt.pname;
      package = nixpkgs-fmt;
      help = nixpkgs-fmt.meta.description;
      category = "linters";
    }
    {
      name = flk.name;
      help = "Build, deploy, and install nixflk";
      category = "main";
      package = flk;
    }
    {
      name = "hooks";
      help = "install git hooks";
      command = "pre-commit install";
    }
    {
      name = "grip";
      help = python38Packages.grip.meta.description;
      category = "servers";
      package = python38Packages.grip;
    }
    {
      name = git.pname;
      help = git.meta.description;
      category = "vcs";
      package = git;
    }
    {
      name = "nix";
      help = nixFlakes.meta.description;
      category = "main";
      command = ''${nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"'';
    }
  ];

}

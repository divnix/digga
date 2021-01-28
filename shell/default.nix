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
      echo "Usage: $(basename "$0") [ up | iso {host} | netboot-ramdisk {host} | netboot-ipxe {host} | install {host} | {host} [switch|boot|test] | home {host} {user} [switch] ]"
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
      nix build $DEVSHELL_ROOT#nixosConfigurations.$2.${build}.iso "${"\${@:3}"}"
    elif [[ "$1" == "netboot-ramdisk" ]]; then
      nix build $DEVSHELL_ROOT#nixosConfigurations.$2.${build}.netbootRamdisk "${"\${@:3}"}"
    elif [[ "$1" == "netboot-ipxe" ]]; then
      nix build $DEVSHELL_ROOT#nixosConfigurations.$2.${build}.netbootIpxeScript "${"\${@:3}"}"
    elif [[ "$1" == "install" ]]; then
      sudo nixos-install --flake "$DEVSHELL_ROOT#$2" "${"\${@:3}"}"
    elif [[ "$1" == "home" ]]; then
      nix build ./#hmActivationPackages.$2.$3
      if [[ "$4" == "switch" ]]; then
        ./result/activate && unlink result
      fi
    else
      sudo nixos-rebuild --flake "$DEVSHELL_ROOT#$1" "${"\${@:2}"}"
    fi
  '';

  name = "flk";
in
pkgs.devshell.mkShell {
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

  git.hooks = with pkgs; {
    enable = true;
    pre-commit.text = ''
      if ${git}/bin/git rev-parse --verify HEAD >/dev/null 2>&1
      then
        against=HEAD
      else
        # Initial commit: diff against an empty tree object
        against=$(${git}/bin/git hash-object -t tree /dev/null)
      fi
      # Redirect output to stderr.
      exec 1>&2

      # Format staged nix files.
      exec ${nixpkgs-fmt}/bin/nixpkgs-fmt \
        $(
           ${git}/bin/git diff-index --name-only --cached $against -- \
           | ${ripgrep}/bin/rg '\.nix$'
         )
    '';
  };

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

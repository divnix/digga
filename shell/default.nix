{
  system ? builtins.currentSystem,
  inputs ? (import ./.).inputs,
}: let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
  devshell = import inputs.devshell {inherit system;};
  nixBin = "${unstablePkgs.nix}/bin/nix";

  withCategory = category: attrset: attrset // {inherit category;};
  utils = withCategory "utils";
  docs = withCategory "docs";

  makeDocs = {
    name = "make-docs";
    help = "Execute the docs creating jobs and place the results in ./doc";
    command = ''
      nix build "$PRJ_ROOT#jobs.${pkgs.system}.mkApiReferenceTopLevel" \
        && cp result "$PRJ_ROOT/doc/api-reference.md" \
        && chmod 755 "$PRJ_ROOT//doc/api-reference.md"
      nix build "$PRJ_ROOT#jobs.${pkgs.system}.mkApiReferenceChannels" \
        && cp result "$PRJ_ROOT/doc/api-reference-channels.md" \
        && chmod 755 "$PRJ_ROOT//doc/api-reference-channels.md"
      nix build "$PRJ_ROOT#jobs.${pkgs.system}.mkApiReferenceHome" \
        && cp result "$PRJ_ROOT/doc/api-reference-home.md" \
        && chmod 755 "$PRJ_ROOT//doc/api-reference-home.md"
      nix build "$PRJ_ROOT#jobs.${pkgs.system}.mkApiReferenceDevshell" \
        && cp result "$PRJ_ROOT/doc/api-reference-devshell.md" \
        && chmod 755 "$PRJ_ROOT//doc/api-reference-devshell.md"
      nix build "$PRJ_ROOT#jobs.${pkgs.system}.mkApiReferenceNixos" \
        && cp result "$PRJ_ROOT/doc/api-reference-nixos.md" \
        && chmod 755 "$PRJ_ROOT//doc/api-reference-nixos.md"
    '';
  };

  test = type: name:
    withCategory "tests" {
      name = "check-${name}";
      help = "Checks ${name} ${type}";
      command = ''
        set -e

        flake="$PRJ_ROOT/${type}/${name}"
        tempdigga=path:$PRJ_ROOT

        trap_err() {
          local ret=$?
          echo -e \
            "\033[1m\033[31m""exit $ret: \033[0m\033[1m""command [$BASH_COMMAND] failed""\033[0m"
        }

        is () { [ "$1" -eq "0" ]; }

        trap 'trap_err' ERR

        # --------------------------------------------------------------------------------

        cd $PRJ_ROOT/${type}/${name}

        ${nixBin} flake show $flake "$@" --override-input digga $tempdigga
        ${nixBin} flake check $flake "$@" --override-input digga $tempdigga
      '';
    };

  update = type: name:
    withCategory "updates" {
      name = "update-${name}";
      help = "Updates ${name} ${type}";
      command = ''
        set -e

        flake="$PRJ_ROOT/${type}/${name}"

        trap_err() {
          local ret=$?
          echo -e \
            "\033[1m\033[31m""exit $ret: \033[0m\033[1m""command [$BASH_COMMAND] failed""\033[0m"
        }

        is () { [ "$1" -eq "0" ]; }

        trap 'trap_err' ERR

        # --------------------------------------------------------------------------------

        ${nixBin} flake update $flake "$@"
      '';
    };
in
  devshell.mkShell {
    imports = [(devshell.extraModulesDir + "/git/hooks.nix")];
    name = "digga";
    packages = with pkgs; [
      fd
      editorconfig-checker
      treefmt
      alejandra
      nodePackages.prettier
      shellcheck
      shfmt
      # Use the latest stable version of nix
      unstablePkgs.nix
    ];

    env = [
      {
        name = "NIX_CONFIG";
        value = ''          extra-experimental-features = nix-command flakes
                  extra-substituters = https://nrdxp.cachix.org https://nix-community.cachix.org
                  extra-trusted-public-keys = nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs='';
      }
    ];

    commands = [
      (utils {
        name = "fmt";
        help = "Check formatting";
        command = "treefmt \${@} $PRJ_ROOT";
      })
      (utils {
        name = "evalnix";
        help = "Check Nix parsing";
        command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
      })

      (test "examples" "devos")
      (test "examples" "groupByConfig")
      (test "examples" "hmOnly")
      (test "examples" "all" // {command = "check-devos && check-groupByConfig && check-hmOnly";})

      (update "examples" "devos")
      (update "examples" "groupByConfig")
      (update "examples" "hmOnly")
      (update "examples" "all" // {command = "update-devos && update-groupByConfig && update-hmOnly";})

      (docs {package = pkgs.mdbook;})
      (docs makeDocs)
    ];

    git.hooks = {
      enable = true;
      pre-commit.text = builtins.readFile ./pre-commit.sh;
    };
  }

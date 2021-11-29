{ inputs, system ? builtins.currentSystem }:
let

  pkgs = import inputs.nixpkgs {
    inherit system; config = { };
    overlays = [ ];
  };
  devshell = import inputs.devshell { inherit pkgs system; };

  withCategory = category: attrset: attrset // { inherit category; };
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

  test = type: name: withCategory "tests" {
    name = "check-${name}";
    help = "Checks ${name} ${type}";
    command = ''
      set -e
      # set -x

      diggaurl=
      lockfile_updated=1
      lockfile_present=1
      tempdigga="\"path:$PRJ_ROOT\""

      cleanup() {
        if is $lockfile_present; then
          git checkout -- flake.lock
        elif is $lockfile_updated; then
          git rm -f flake.lock
        fi
        # ensure: restore input
        [ -z $diggaurl ] || sed -i "s|$tempdigga|$diggaurl|g" flake.nix
      }

      digga_fixture() {
        # ensure: replace input
        diggaurl=$({ grep -o '"github:divnix/digga.*"' flake.nix || true; })
        [ -z $diggaurl ] || sed -i "s|$diggaurl|$tempdigga|g" flake.nix
      }

      trap_err() {
        local ret=$?
        cleanup
        echo -e \
          "\033[1m\033[31m""exit $ret: \033[0m\033[1m""command [$BASH_COMMAND] failed""\033[0m"
      }

      is () { [ "$1" -eq "0" ]; }

      trap 'trap_err' ERR

      # --------------------------------------------------------------------------------

      cd $PRJ_ROOT/${type}/${name}

      digga_fixture

      test -f flake.lock && lockfile_present=$? || true
      ${pkgs.nixUnstable}/bin/nix flake lock --update-input digga "$@"; lockfile_updated=$?;
      ${pkgs.nixUnstable}/bin/nix flake show "$@"
      ${pkgs.nixUnstable}/bin/nix flake check "$@"

      cleanup
    '';
  };

in
devshell.mkShell {
  name = "digga";
  packages = with pkgs; [
    fd
    nixpkgs-fmt
    nixUnstable
  ];

  env = [
    {
      name = "NIX_CONFIG";
      value =
        ''extra-experimental-features = nix-command flakes ca-references
        extra-substituters = https://nrdxp.cachix.org https://nix-community.cachix.org
        extra-trusted-public-keys = nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs='';
    }
  ];

  # tempfix: remove when merged https://github.com/numtide/devshell/pull/123
  devshell.startup.load_profiles = pkgs.lib.mkForce (pkgs.lib.noDepEntry ''
    # PATH is devshell's exorbitant privilige:
    # fence against its pollution
    _PATH=''${PATH}
    # Load installed profiles
    for file in "$DEVSHELL_DIR/etc/profile.d/"*.sh; do
      # If that folder doesn't exist, bash loves to return the whole glob
      [[ -f "$file" ]] && source "$file"
    done
    # Exert exorbitant privilige and leave no trace
    export PATH=''${_PATH}
    unset _PATH
  '');

  commands = [
    (utils {
      command = "git rm --ignore-unmatch -f $PRJ_ROOT/{tests,examples}/*/flake.lock";
      help = "Remove all lock files";
      name = "rm-locks";
    })
    (utils {
      name = "fmt";
      help = "Check Nix formatting";
      command = "nixpkgs-fmt \${@} $PRJ_ROOT";
    })
    (utils {
      name = "evalnix";
      help = "Check Nix parsing";
      command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
    })

    (test "examples" "downstream")
    (test "examples" "groupByConfig")
    (test "examples" "hmOnly")
    (test "examples" "all" // { command = "check-downstream && check-groupByConfig && check-hmOnly"; })
    (docs { package = pkgs.mdbook; })
    (docs makeDocs)

  ];
}

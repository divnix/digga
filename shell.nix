{ inputs, system ? builtins.currentSystem }:
let

  pkgs = import inputs.nixpkgs { inherit system; config = { }; overlays = [ ]; };
  devshell = import inputs.devshell { inherit pkgs system; };

  withCategory = category: attrset: attrset // { inherit category; };
  util = withCategory "utils";

  test = name: withCategory "tests" {
    name = "check-${name}";
    help = "Checks ${name} example";
    command = ''
      set -e

      diggaurl=
      lockfile_updated=1
      lockfile_present=1

      cleanup() {
        if is $lockfile_present; then
          git checkout -- flake.lock
        elif is $lockfile_updated; then
          git rm -f flake.lock
        fi
        # ensure: restore input
        [ -z $diggaurl ] || sed -i "s|\"path:../../\"|$diggaurl|g" flake.nix
      }

      digga_fixture() {
        # ensure: replace input
        diggaurl=$({ grep -o '"github:divnix/digga.*"' flake.nix || true; })
        sed -i 's|"github:divnix/digga/.*"|"path:../../"|g' flake.nix
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

      cd $DEVSHELL_ROOT/examples/${name}

      digga_fixture

      test -f flake.lock && lockfile_present=$? || true
      ${patchedNixUnstable}/bin/nix flake lock --update-input digga "$@"; lockfile_updated=$?;
      ${patchedNixUnstable}/bin/nix flake show "$@"
      ${patchedNixUnstable}/bin/nix flake check "$@"

      cleanup
    '';
  };

  patchedNixUnstable = pkgs.nixUnstable.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        name = "fix-follows.diff";
        url = "https://github.com/CitadelCore/nix/commit/cfef23c040c950222b3128b9da464d9fe6810d79.diff";
        sha256 = "sha256-KpYSX/k7FQQWD4u4bUPFOUlPV4FyfuDy4OhgDm+bkx0=";
      })
    ];
  });

in
devshell.mkShell {
  name = "digga";
  packages = with pkgs; [
    fd
    nixpkgs-fmt
    patchedNixUnstable
  ];

  commands = [
    {
      command = "git rm --ignore-unmatch -f $DEVSHELL_ROOT/{tests,examples}/*/flake.lock";
      help = "Remove all lock files";
      name = "rm-locks";
    }
    {
      name = "fmt";
      help = "Check Nix formatting";
      command = "nixpkgs-fmt \${@} $DEVSHELL_ROOT";
    }
    {
      name = "evalnix";
      help = "Check Nix parsing";
      command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
    }

    (test "downstream")
    (test "groupByConfig")
    (test "all" // { command = "check-downstream && check-groupByConfig"; })

  ];
}

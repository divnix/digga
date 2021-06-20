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
      cd $DEVSHELL_ROOT/examples/${name}
      ${patchedNixUnstable}/bin/nix flake lock --update-input digga || git rm -f flake.lock
      ${patchedNixUnstable}/bin/nix flake show || git rm -f flake.lock
      ${patchedNixUnstable}/bin/nix flake check || git rm -f flake.lock
      git rm -f flake.lock
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

    (test "classicalDevos")
    (test "groupByConfig")
    (test "all" // { command = "check-classicalDevos && groupByConfig"; })

  ];
}

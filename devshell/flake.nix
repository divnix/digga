{
  description = "Digga (formerly DevOS) devshell";

  inputs = {
    # Parent flake
    main.url = "path:../.";

    # Inherited inputs
    nixpkgs.follows = "main/nixpkgs";
    devshell.follows = "main/devshell";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"] (
      system: let
        inherit
          (inputs.main.inputs.std.deSystemize system inputs)
          main
          devshell
          nixpkgs
          nixpkgs-unstable
          ;
        inherit
          (main.inputs.std.deSystemize system inputs.main.inputs)
          std
          ;
        withCategory = category: attrset: attrset // {inherit category;};
        utils = withCategory "utils";
        docs = withCategory "docs";

        makeDocs = {
          name = "make-docs";
          help = "Execute the docs creating jobs and place the results in ./doc";
          command = ''
            nix build "$PRJ_ROOT#jobs.${system}.mkApiReferenceTopLevel" \
              && cp result "$PRJ_ROOT/doc/api-reference.md" \
              && chmod 755 "$PRJ_ROOT//doc/api-reference.md"
            nix build "$PRJ_ROOT#jobs.${system}.mkApiReferenceChannels" \
              && cp result "$PRJ_ROOT/doc/api-reference-channels.md" \
              && chmod 755 "$PRJ_ROOT//doc/api-reference-channels.md"
            nix build "$PRJ_ROOT#jobs.${system}.mkApiReferenceHome" \
              && cp result "$PRJ_ROOT/doc/api-reference-home.md" \
              && chmod 755 "$PRJ_ROOT//doc/api-reference-home.md"
            nix build "$PRJ_ROOT#jobs.${system}.mkApiReferenceDevshell" \
              && cp result "$PRJ_ROOT/doc/api-reference-devshell.md" \
              && chmod 755 "$PRJ_ROOT//doc/api-reference-devshell.md"
            nix build "$PRJ_ROOT#jobs.${system}.mkApiReferenceNixos" \
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
                [ -z $diggaurl ] || ${nixpkgs.legacyPackages.gnused}/bin/sed -i "s|$tempdigga|$diggaurl|g" flake.nix
              }

              digga_fixture() {
                # ensure: replace input
                diggaurl=$({ grep -o '"github:divnix/digga.*"' flake.nix || true; })
                [ -z $diggaurl ] || ${nixpkgs.legacyPackages.gnused}/bin/sed -i "s|$diggaurl|$tempdigga|g" flake.nix
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
              ${nixpkgs-unstable.legacyPackages.nixUnstable}/bin/nix flake lock --update-input digga "$@"; lockfile_updated=$?;
              ${nixpkgs-unstable.legacyPackages.nixUnstable}/bin/nix flake show "$@"
              ${nixpkgs-unstable.legacyPackages.nixUnstable}/bin/nix flake check "$@"

              cleanup
            '';
          };
      in {
        devShells.default = devshell.legacyPackages.mkShell (
          {extraModulesPath, ...}: {
            name = "digga-fka-devos";

            imports = [
              "${extraModulesPath}/git/hooks.nix"
              std.std.devshellProfiles.default
            ];

            git.hooks = {
              enable = true;
              pre-commit.text = builtins.readFile ./pre-commit.sh;
            };

            cellsFrom = "./nix";
            packages = [
              # formatters
              nixpkgs-unstable.legacyPackages.alejandra
              nixpkgs.legacyPackages.nodePackages.prettier
              nixpkgs.legacyPackages.shfmt
              nixpkgs.legacyPackages.editorconfig-checker

              # deps for devshell scripts
              nixpkgs.legacyPackages.fd
            ];
            commands = [
              (utils {package = nixpkgs.legacyPackages.treefmt;})
              (utils {
                command = "git rm --ignore-unmatch -f $PRJ_ROOT/{tests,examples}/*/flake.lock";
                help = "Remove all lock files";
                name = "rm-locks";
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
              (docs {package = nixpkgs.legacyPackages.mdbook;})
              (docs makeDocs)
            ];
          }
        );
      }
    );
}

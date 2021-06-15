{ pkgs, lib }:
let
  fullFlake = import ./fullFlake { inherit pkgs lib; };

  mkOutputTest = output:
    let
      outputs = builtins.attrValues (fullFlake.${output}.${pkgs.system});
    in
    pkgs.runCommandNoCC "${output}-test"
      {
        buildInputs = outputs;
      } ''
      echo "${toString outputs}" > $out
    '';
in
{
  libTests = pkgs.runCommandNoCC "devos-lib-tests"
    {
      buildInputs = [
        pkgs.nix
        (
          let tests = import ./lib { inherit pkgs lib; }; in
          if tests == [ ] then null
          else throw (builtins.toJSON tests)
        )
      ];
    } ''
    datadir="${pkgs.nix}/share"
    export TEST_ROOT=$(pwd)/test-tmp
    export NIX_BUILD_HOOK=
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=$TEST_ROOT/store
    export PAGER=cat
    cacheDir=$TEST_ROOT/binary-cache
    nix-store --init

    touch $out
  '';

  checksTest = mkOutputTest "checks" // {
    # debug the fullFLake through repl at checks.<system>.checksTest.fullFlake
    inherit fullFlake;
  };

  devShellTest = fullFlake.devShell.${pkgs.system};
}

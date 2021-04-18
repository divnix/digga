{ pkgs, lib, dev, ... }:

pkgs.runCommandNoCC "devos-lib-tests"
    {
      buildInputs = [
        pkgs.nix
        (
          let tests = import ./lib.nix { inherit pkgs lib dev; }; in
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
  ''

{ pkgs-lib, pkgs, system, inputs, nixos, lib, ... }:
let
  mkChecks = { hosts, nodes, homes ? { } }:
    let
      deployHosts = lib.filterAttrs
        (n: _: hosts.${n}.config.nixpkgs.system == system)
        nodes;
      deployChecks = inputs.deploy.lib.${system}.deployChecks { nodes = deployHosts; };
      tests =
        { libTests = libTests; }
        // lib.optionalAttrs (deployHosts != { }) {
          profilesTest = profilesTest (hosts.${(builtins.head (builtins.attrNames deployHosts))});
        } // lib.mapAttrs (n: v: v.activationPackage) homes;

    in
    lib.recursiveUpdate tests deployChecks;

  mkTest = host:
    let
      nixosTesting =
        (import "${nixos}/nixos/lib/testing-python.nix" {
          inherit system;
          inherit (host.config.lib) specialArgs;
          inherit pkgs;
          extraConfigurations = [
            host.config.lib.testModule
          ];
        });
    in
    test:
    let
      loadedTest =
        if builtins.typeOf test == "path"
        then import test
        else test;
      calledTest =
        if pkgs.lib.isFunction loadedTest
        then pkgs.callPackage loadedTest { }
        else loadedTest;
    in
    nixosTesting.makeTest calledTest;

  profilesTest = host: mkTest host {
    name = "profiles";

    machine = { suites, ... }: {
      imports = suites.allProfiles ++ suites.allUsers;
    };

    testScript = ''
      machine.systemctl("is-system-running --wait")
    '';
  };

  libTests = pkgs.runCommandNoCC "devos-lib-tests"
    {
      buildInputs = [
        pkgs.nix
        (
          let tests = pkgs-lib.callLibs ./lib.nix;
          in
          if tests == [ ]
          then null
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
in
{ inherit mkTest libTests profilesTest mkChecks; }

{ self, pkgs }:
let
  inherit (self.inputs) nixos;
  inherit (self.nixosConfigurations.NixOS.config.lib) testModule specialArgs;

  mkTest =
    let
      nixosTesting =
        (import "${nixos}/nixos/lib/testing-python.nix" {
          inherit (pkgs.stdenv.hostPlatform) system;
          inherit specialArgs;
          inherit pkgs;
          extraConfigurations = [
            testModule
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
in
{
  profilesTest = mkTest {
    name = "profiles";

    machine = { suites, ... }: {
      imports = suites.allProfiles ++ suites.allUsers;
    };

    testScript = ''
      machine.systemctl("is-system-running --wait")
    '';
  };

  homeTest = self.homeConfigurations."nixos@NixOS".home.activationPackage;

  libTests = pkgs.runCommandNoCC "devos-lib-tests"
    {
      buildInputs = [
        pkgs.nix
        (
          let tests = import ./lib.nix { inherit self pkgs; };
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
}


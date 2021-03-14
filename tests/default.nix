{ self, pkgs }:
let
  inherit (self.inputs) nixos;
  inherit (self.nixosConfigurations.NixOS.config.lib) testModule specialArgs;

  # current release 20.09 does not support the specialArgs required for us
  # to use tests as we would normally use hosts. Using the "testing-python.nix"
  # from the override flake would build the test-vm from an unstable os
  # different than the one our systems are running. Instead simply patch nixpkgs
  # to include the updated version. This can be removed in the next release
  patchedNixpkgs =
    pkgs.stdenv.mkDerivation {
      name = "nixpkgs-patched";

      src = nixos;
      patches = [ ./0004-nixos-testing-Add-support-for-specialArgs.patch ];

      dontBuild = true;
      dontFixup = true;

      versionSuffix = "pre${
    if nixos ? lastModified
    then builtins.substring 0 8 (nixos.lastModifiedDate or nixos.lastModified)
    else toString nixos.revCount}.${nixos.shortRev or "dirty"}";

      configurePhase = ''
        echo -n $VERSION_SUFFIX > .version-suffix
        echo -n ${nixos.rev or nixos.shortRev or "dirty"} > .git-revision
      '';

      installPhase = ''
        cp -r $PWD $out
      '';
    };

  mkTest =
    let
      nixosTesting =
        (import "${patchedNixpkgs}/nixos/lib/testing-python.nix" {
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
  x86_64-linux = {
    profilesTest = mkTest {
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
  };
}

{ lib, nixpkgs, deploy, system }:
let
  pkgs = import nixpkgs { inherit system; overlays = []; config = {}; };

  mkChecks = { hosts, nodes, homes ? { } }:
    let
      deployHosts = lib.filterAttrs
        (n: _: hosts.${n}.config.nixpkgs.system == system)
        nodes;
      deployChecks = deploy.lib.${system}.deployChecks { nodes = deployHosts; };
      tests =
        lib.optionalAttrs (deployHosts != { }) {
          profilesTest = profilesTest (hosts.${(builtins.head (builtins.attrNames deployHosts))});
        } // lib.mapAttrs (n: v: v.activationPackage) homes;

    in
    lib.recursiveUpdate tests deployChecks;

  mkTest = host:
    let
      nixosTesting =
        (import "${nixpkgs}/nixos/lib/testing-python.nix" {
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
in
{ inherit mkTest profilesTest mkChecks; }

{ lib }:
let

  mkTest = { pkgs, host }:
    let
      nixosTesting =
        (import "${toString pkgs.path}/nixos/lib/testing-python.nix" {
          inherit (pkgs) system;
          inherit (host.config.lib) specialArgs;
          inherit pkgs;
          extraConfigurations = host._module.args.modules;
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

  profilesTest = args@{ host, ... }: mkTest args {
    name = "profiles";

    machine = { suites, ... }: {
      imports = suites.allProfiles;
    };

    testScript = ''
      ${host.config.networking.hostName}.systemctl("is-system-running --wait")
    '';
  };
in
{ inherit mkTest profilesTest; }

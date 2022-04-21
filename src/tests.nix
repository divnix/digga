{lib}: let
  maybeImport = obj:
    if (builtins.isPath obj || builtins.isString obj)
    then import obj
    else obj;

  maybeCallTest = pkgs: obj:
    if lib.isFunction obj
    then pkgs.callPackage obj {}
    else obj;

  mkTest = host: test: let
    pkgs = host._module.args.pkgs;
    nixosTesting = import "${toString pkgs.path}/nixos/lib/testing-python.nix" {
      inherit pkgs;
      inherit (pkgs) system;
      inherit (host.config.lib) specialArgs;
      extraConfigurations = host._module.args.modules;
    };
  in
    nixosTesting.makeTest (maybeCallTest pkgs (maybeImport test));

  allProfilesTest = {
    name = "allProfiles";

    machine = {suites ? null, ...}: {
      imports = let
        allProfiles =
          lib.foldl
          (lhs: rhs: lhs ++ rhs) []
          (builtins.attrValues suites);
      in
        allProfiles;
    };

    testScript = ''
      machines[0].systemctl("is-system-running --wait")
    '';
  };
in {inherit mkTest allProfilesTest;}

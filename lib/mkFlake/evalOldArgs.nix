{ userSelf, lib, inputs, ... }:

{ args }:
let
  argOpts = with lib; { config, options, ... }:
    let
      inherit (lib) os;

      inherit (config) self;

      inputAttrs = with types; functionTo attrs;
      moduleType = with types; anything // {
        inherit (submodule { }) check;
        description = "valid module";
      };
    in
    {
      options = with types; {
        self = mkOption {
          type = addCheck attrs lib.isStorePath;
          description = "The flake to create the devos outputs for";
        };
        hosts = mkOption {
          type = path;
          default = "${userSelf}/hosts";
          defaultText = "\${userSelf}/hosts";
          apply = toString;
          description = ''
            Path to directory containing host configurations that will be exported
            to the 'nixosConfigurations' output.
          '';
        };
        packages = mkOption {
          # functionTo changes arg names which breaks flake check
          type = types.anything // {
            check = builtins.isFunction;
            description = "Nixpkgs overlay";
          };
          default = (final: prev: { });
          defaultText = "(final: prev: {})";
          description = ''
            Overlay for custom packages that will be included in treewide 'pkgs'.
            This should follow the standard nixpkgs overlay format - two argument function
            that returns an attrset.
            These packages will be exported to the 'packages' and 'legacyPackages' outputs.
          '';
        };
        modules = mkOption {
          type = listOf moduleType;
          default = [ ];
          apply = lib.pathsToImportedAttrs;
          description = ''
            list of modules to include in confgurations and export in 'nixosModules' output
          '';
        };
        userModules = mkOption {
          type = listOf moduleType;
          default = [ ];
          apply = lib.pathsToImportedAttrs;
          description = ''
            list of modules to include in home-manager configurations and export in
            'homeModules' output
          '';
        };
        profiles = mkOption {
          type = path;
          default = "${userSelf}/profiles";
          defaultText = "\${userSelf}/profiles";
          apply = x: os.mkProfileAttrs (toString x);
          description = "path to profiles folder that can be collected into suites";
        };
        userProfiles = mkOption {
          type = path;
          default = "${userSelf}/users/profiles";
          defaultText = "\${userSelf}/users/profiles";
          apply = x: os.mkProfileAttrs (toString x);
          description = "path to user profiles folder that can be collected into userSuites";
        };
        suites =
          let
            defaults = { user = { }; system = { }; };
          in
          mkOption {
            type = inputAttrs;
            default = { ... }: defaults;
            defaultText = "{ user = {}; system = {}; }";
            apply = suites: defaults // os.mkSuites {
              inherit suites;
              inherit (config) profiles users userProfiles;
            };
            description = ''
              Function with inputs 'users' and 'profiles' that returns attribute set
              with user and system suites. The former for Home Manager and the latter
              for nixos configurations.
              These can be accessed through the 'suites' specialArg in each config system.
            '';
          };
        users = mkOption {
          type = path;
          default = "${userSelf}/users";
          defaultText = "\${userSelf}/users";
          apply = x: os.mkProfileAttrs (toString x);
          description = ''
            path to folder containing profiles that define system users
          '';
        };
        extern =
          let
            defaults = {
              modules = [ ];
              overlays = [ ];
              specialArgs = { };
              userModules = [ ];
              userSpecialArgs = { };
            };
          in
          mkOption {
            type = inputAttrs;
            default = { ... }: defaults;
            defaultText = ''
              { modules = []; overlays = []; specialArgs = []; userModules = []; userSpecialArgs = []; }
            '';
            # So unneeded extern attributes can safely be deleted
            apply = x: defaults // (x { inputs = inputs // userSelf.inputs; });
            description = ''
              Function with argument 'inputs' that contains all devos and ''${userSelf}'s inputs.
              The function should return an attribute set with modules, overlays, and
              specialArgs to be included across nixos and home manager configurations.
              Only attributes that are used should be returned.
            '';
          };
        overlays = mkOption {
          type = path;
          default = "${userSelf}/overlays";
          defaultText = "\${userSelf}/overlays";
          apply = x: lib.pathsToImportedAttrs (lib.pathsIn (toString x));
          description = ''
            path to folder containing overlays which will be applied to pkgs and exported in
            the 'overlays' output
          '';
        };
        overrides = mkOption rec {
          type = attrs;
          default = { modules = [ ]; disabledModules = [ ]; packages = _: _: _: { }; };
          defaultText = "{ modules = []; disabledModules = []; packages = {}; }";
          apply = x: default // x;
          description = "attrset of packages and modules that will be pulled from nixpkgs master";
        };
      };
    };
in
lib.evalModules {
  modules = [ argOpts args ];
}

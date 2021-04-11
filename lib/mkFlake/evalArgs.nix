{ self, dev, nixos, inputs, ... }:

{ args }:
let
  argOpts = with nixos.lib; { config, options, ... }:
    let
      inherit (dev) os;

      inherit (config) self;

      inputAttrs = with types; functionTo attrs;
      moduleType = with types; anything // {
        inherit (submodule { }) check;
        description = "valid module";
      };

      pathTo = elemType: mkOptionType {
        name = "pathTo";
        description = "path that evaluates to a(n) ${elemType.name}";
        check = x: elemType.check x;
        merge = loc: defs:
          (lib.mergeDefinitions loc elemType (map
            (x: {
              inherit (x) file;
              value = maybeImport x.value;
            })
          defs)).mergedValue;
        getSubOptions = elemType.getSubOptions;
        getSubModules = elemType.getSubModules;
        substSubModules = m: pathTo (elemType.substSubModules m);
      };

      conceptsModule = { path, ... }: {
        options = {
          hosts = mkOption {
            type = path;
            default = "${self}/hosts";
            defaultText = "\${self}/hosts";
            apply = toString;
            description = ''
              Path to directory containing host configurations that will be exported
              to the 'nixosConfigurations' output.
            '';
          };
          modules = mkOption {
            type = pathTo (listOf moduleType);
            default = [ ];
            apply = dev.pathsToImportedAttrs;
            description = ''
              list of modules to include in confgurations and export in 'nixosModules' output
            '';
          };
          profiles = mkOption {
            type = path;
            default = "${self}/profiles";
            defaultText = "\${self}/profiles";
            apply = x: os.mkProfileAttrs (toString x);
            description = "path to profiles folder that can be collected into suites";
          };
          suites = mkOption {
            type = pathTo inputAttrs;
            default = _: {};
            apply = suites: os.mkSuites {
              inherit suites;
              inherit (config) profiles;
            };
            description = ''
              Function with inputs 'users' and 'profiles' that returns attribute set
              with user and system suites. The former for Home Manager and the latter
              for nixos configurations.
              These can be accessed through the 'suites' specialArg in each config system.
            '';
          };
        };
      };
    in
    {
      options = with types; {
        self = mkOption {
          type = addCheck attrs nixos.lib.isStorePath;
          description = "The flake to create the devos outputs for";
        };
        defaultSystem = mkOption {
          type = enum (nixos.lib.platforms.all);
          default = "x86_64-linux";
          description = "The default system for your hosts";
        };
        packages = mkOption {
          # functionTo changes arg names which breaks flake check
          default = (final: prev: { });
          defaultText = "(final: prev: {})";
          description = ''
            Overlay for custom packages that will be included in treewide 'pkgs'.
            This should follow the standard nixpkgs overlay format - two argument function
            that returns an attrset.
            These packages will be exported to the 'packages' and 'legacyPackages' outputs.
          '';
        };
        nixos = mkOption {
          type = types.submodule conceptsModule;
          default = {};
          description = ''
            hosts, modules, suites, and profiles for nixos
          '';
        };
        overlays = mkOption {
          type = path;
          default = "${self}/overlays";
          defaultText = "\${self}/overlays";
          apply = x: dev.pathsToImportedAttrs (dev.pathsIn (toString x));
          description = ''
            path to folder containing overlays which will be applied to pkgs and exported in
            the 'overlays' output
          '';
        };
      };
    };
in
nixos.lib.evalModules {
  modules = [ argOpts args ];
}

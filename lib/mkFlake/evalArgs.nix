{ self, dev, nixos, inputs, utils, ... }:

{ args }:
let
  argOpts = with nixos.lib; { config, options, ... }:
    let
      inherit (dev) os;

      inherit (config) self;

      maybeImport = obj:
        if (builtins.typeOf obj == "path") || (builtins.typeOf obj == "string") then
          import obj
        else
          obj;

      # Custom types needed for arguments
      inputAttrs = with types; functionTo attrs;
      moduleType = with types; anything // {
        inherit (submodule { }) check;
        description = "valid module";
      };
      overlayType = types.anything // {
        check = builtins.isFunction;
        description = "valid Nixpkgs overlay";
      };
      systemType = types.enum (builtins.attrValues config.supportedSystems);
      flakeType = with types; addCheck attrs nixos.lib.isStorePath;

      pathTo = elemType: mkOptionType {
        name = "pathTo";
        description = "path that evaluates to a(n) ${elemType.name}";
        check = x: elemType.check (maybeImport x);
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

      # Submodules needed for API containers
      channelsModule = {
        options = with types; {
          input = mkOption {
            type = flakeType;
            default = inputs.nixos;
            description = ''
              nixpkgs flake input to use for this channel
            '';
          };
          overlays = mkOption {
            type = pathTo (listOf overlayType);
            default = [ ];
            description = ''
              overlays to apply to this channel
              these will get exported under the 'overlays' flake output as <channel>/<name>
            '';
          };
          externalOverlays = mkOption {
            type = pathTo (listOf overlayType);
            default = [];
            description = ''
              overlays to apply to the channel that don't get exported to the flake output
              useful to include overlays from inputs
            '';
          };
          config = mkOption {
            type = pathTo attrs;
            default = {};
            description = ''
              nixpkgs config for this channel
            '';
          };
        };
      };

      configsModule = { name, ... }: {
        options = with types; {
          system = mkOption {
            type = systemType;
            default = config.defaultSystem;
            description = ''
              system for this config
            '';
          };
          channelName = mkOption {
            type = types.enum (builtins.attrValues self.channels);
            default = "nixpkgs";
            description = ''
              Channel this config should follow
            '';
          };
          modules = mkOption {
            type = pathTo moduleType;
            default = [ ];
            description = ''
              The configuration for this config
            '';
          };
          externalmodules = mkOption {
            type = pathTo moduleType;
            default = [ ];
            description = ''
              The configuration for this config
            '';
          };
        };
      };

      conceptsModule = { name, ... }: mkMerge [
        # Home-manager's configs get exported automatically from nixos.hosts
        # So there is no need for a config options in the home namespace
        (optionalAttrs (name != "home") {
          configDefaults = mkOption {
            type = submodule configType;
            default = { };
            description = ''
              defaults for all configs
            '';
          };
          configs = mkOption {
            type = pathTo (attrsOf (submodule configType));
            default = { };
            description = ''
              configurations to include in the ${name}Configurations output
            '';
          };
        })
        {
          options = with types; {
            modules = mkOption {
              type = pathTo (listOf moduleType);
              default = [ ];
              apply = dev.pathsToImportedAttrs;
              description = ''
                list of modules to include in confgurations and export in '${name}Modules' output
              '';
            };
            externalModules = mkOption {
              type = pathTo (listOf moduleType);
              default = [ ];
              apply = dev.pathsToImportedAttrs;
              description = ''
                list of modules to include in confguration but these are not exported to the '${name}Modules' output
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
                Function with the input of 'profiles' that returns an attribute set
                with the suites for this config system.
                These can be accessed through the 'suites' special argument.
              '';
            };
          };
        }
      ];
    in
    {
      options = with types; {
        self = mkOption {
          type = flakeType;
          description = "The flake to create the devos outputs for";
        };
        supportedSystems = mkOption {
          type = listOf str;
          default = utils.lib.defaultSystems;
          description = ''
            The systems supported by this flake
          '';
        };
        channels = mkOption {
          type = attrsOf (submodule channelsModule);
          default = {
            nixpkgs = {
              input = inputs.nixos;
            };
          };
          description =
        };
        nixos = mkOption {
          type = types.submodule conceptsModule;
          default = {};
          description = ''
            hosts, modules, suites, and profiles for nixos
          '';
        };
        home = mkOption {
          type = type.submodule conceptsModule;
          default = {};
          description = ''
            hosts, modules, suites, and profiles for home-manager
          '';
        };
      };
    };
in
nixos.lib.evalModules {
  modules = [ argOpts args ];
}

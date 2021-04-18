{ userSelf, lib, nixpkgs, utils, ... }:

{ args }:
let
  argOpts = with lib; { config, ... }:
    let
      inherit (lib) os;

      inherit (config) self;

      maybeImport = obj:
        if (builtins.typeOf obj == "path") || (builtins.typeOf obj == "string") then
          import obj
        else
          obj;

      /* Custom types needed for arguments */

      moduleType = with types; anything // {
        inherit (submodule { }) check;
        description = "valid module";
      };
      overlayType = types.anything // {
        check = builtins.isFunction;
        description = "valid Nixpkgs overlay";
      };
      systemType = types.enum config.supportedSystems;
      flakeType = with types; (addCheck attrs lib.isStorePath) // {
        description = "nix flake";
      };

      # Applys maybeImport during merge and before check
      # To simplify apply keys and improve type checking
      pathTo = elemType: mkOptionType {
        name = "pathTo";
        description = "path that evaluates to a(n) ${elemType.name}";
        check = x: elemType.check (maybeImport x);
        merge = loc: defs:
          (mergeDefinitions loc elemType (map
            (x: {
              inherit (x) file;
              value = maybeImport x.value;
            })
            defs)).mergedValue;
        getSubOptions = elemType.getSubOptions;
        getSubModules = elemType.getSubModules;
        substSubModules = m: pathTo (elemType.substSubModules m);
      };


      /* Submodules needed for API containers */

      channelsModule = {
        options = with types; {
          input = mkOption {
            type = flakeType;
            default = nixpkgs;
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
            default = [ ];
            description = ''
              overlays to apply to the channel that don't get exported to the flake output
              useful to include overlays from inputs
            '';
          };
          config = mkOption {
            type = pathTo attrs;
            default = { };
            description = ''
              nixpkgs config for this channel
            '';
          };
        };
      };

      configModule = {
        options = with types; {
          system = mkOption {
            type = systemType;
            default = "x86_64-linux";
            description = ''
              system for this config
            '';
          };
          channelName = mkOption {
            type = types.enum (builtins.attrValues config.channels);
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
          externalModules = mkOption {
            type = pathTo moduleType;
            default = [ ];
            description = ''
              The configuration for this config
            '';
          };
        };
      };

      # Home-manager's configs get exported automatically from nixos.hosts
      # So there is no need for a config options in the home namespace
      # This is only needed for nixos
      includeConfigsModule = { name, ... }: {
        options = with types; {
          configDefaults = mkOption {
            type = submodule configModule;
            default = { };
            description = ''
              defaults for all configs
            '';
          };
          configs = mkOption {
            type = pathTo (attrsOf (submodule configModule));
            default = { };
            description = ''
              configurations to include in the ${name}Configurations output
            '';
          };
        };
      };

      # Options to import: modules, profiles, suites
      importsModule = { name, ... }: {
        options = with types; {
          modules = mkOption {
            type = pathTo (listOf moduleType);
            default = [ ];
            apply = lib.pathsToImportedAttrs;
            description = ''
              list of modules to include in confgurations and export in '${name}Modules' output
            '';
          };
          externalModules = mkOption {
            type = pathTo (listOf moduleType);
            default = [ ];
            apply = lib.pathsToImportedAttrs;
            description = ''
              list of modules to include in confguration but these are not exported to the '${name}Modules' output
            '';
          };
          profiles = mkOption {
            type = path;
            default = "${userSelf}/profiles";
            defaultText = "\${userSelf}/profiles";
            apply = x: os.mkProfileAttrs (toString x);
            description = "path to profiles folder that can be collected into suites";
          };
          suites = mkOption {
            type = pathTo (functionTo attrs);
            default = _: { };
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
      };
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
        channels =
          let
            default = {
              nixpkgs = {
                input = nixpkgs;
              };
            };
          in
          mkOption {
            type = attrsOf (submodule channelsModule);
            inherit default;
            apply = x: default // x;
            description = ''
              nixpkgs channels to create
            '';
          };
        nixos = mkOption {
          type = submodule [ includeConfigsModule importsModule ];
          default = { };
          description = ''
            hosts, modules, suites, and profiles for nixos
          '';
        };
        home = mkOption {
          type = submodule importsModule;
          default = { };
          description = ''
            hosts, modules, suites, and profiles for home-manager
          '';
        };
      };
    };
in
lib.evalModules {
  modules = [ argOpts args ];
}

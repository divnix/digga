{ lib }:

{ args }:
let
  argOpts = with lib; { config, ... }:
    let
      inherit (lib) os;

      cfg = config;
      inherit (config) self;

      maybeImport = obj:
        if (builtins.typeOf obj == "path") || (builtins.typeOf obj == "string") then
          import obj
        else
          obj;

      /* Custom types needed for arguments */

      moduleType = with types; pathTo (anything // {
        inherit (submodule { }) check;
        description = "valid module";
      });
      overlayType = pathTo (types.anything // {
        check = builtins.isFunction;
        description = "valid Nixpkgs overlay";
      });
      systemType = types.enum config.supportedSystems;
      flakeType = with types; (addCheck attrs lib.isStorePath) // {
        description = "nix flake";
      };

      # Apply maybeImport during merge and before check
      # To simplify apply keys and improve type checking
      pathTo = elemType: with types; coercedTo path maybeImport elemType;

      pathToListOf = elemType: with types; pathTo (listOf elemType);

      coercedListOf = elemType: with types;
        coercedTo elemType (x: flatten (singleton x)) (listOf elemType);

      /* Submodules needed for API containers */

      channelsModule = { name, ... }: {
        options = with types; {
          input = mkOption {
            type = flakeType;
            default = cfg.inputs.${name};
            defaultText = escape [ "<" ">" ] "inputs.<name>";
            description = ''
              nixpkgs flake input to use for this channel
            '';
          };
          overlays = mkOption {
            type = pathToListOf overlayType;
            default = [ ];
            description = escape [ "<" ">" ] ''
              overlays to apply to this channel
              these will get exported under the 'overlays' flake output
              as <channel>/<name> and any overlay pulled from ''\${inputs}
              will be filtered out
            '';
          };
          config = mkOption {
            type = pathTo attrs;
            default = { };
            apply = lib.recursiveUpdate cfg.channelsConfig;
            description = ''
              nixpkgs config for this channel
            '';
          };
        };
      };

      hostModule = {
        options = with types; {
          # anything null in hosts gets filtered out by mkFlake
          system = mkOption {
            type = (nullOr systemType) // {
              description = "system defined in `supportedSystems`";
            };
            default = null;
            description = ''
              system for this host
            '';
          };
          channelName = mkOption {
            type = (nullOr (types.enum (builtins.attrNames config.channels))) // {
              description = "a channel defined in `channels`";
            };
            default = null;
            description = ''
              Channel this host should follow
            '';
          };
        };
      };

      # This is only needed for hostDefaults
      # modules in each host don't get exported
      externalModulesModule = {
        options = {
          externalModules = mkOption {
            type = with types; listOf moduleType;
            default = [ ];
            description = ''
              modules to include that won't be exported
              meant importing modules from external flakes
            '';
          };
        };
      };

      modulesModule = {
        options = {
          modules = mkOption {
            type = with types; coercedListOf moduleType;
            default = [ ];
            description = ''
              modules to include
            '';
          };
        };
      };

      exportModulesModule = name: {
        options = {
          modules = mkOption {
            type = with types; pathToListOf
              # check if the path evaluates to a proper module
              # but this must be a path for the export to work
              (addCheck path (x: moduleType.check (import x)));
            default = [ ];
            description = ''
              modules to include in all hosts and export to ${name}Modules output
            '';
          };
        };
      };



      # Home-manager's configs get exported automatically from nixos.hosts
      # So there is no need for a host options in the home namespace
      # This is only needed for nixos
      includeHostsModule = name: {
        options = with types; {
          hostDefaults = mkOption {
            type = submodule [
              hostModule
              externalModulesModule
              (exportModulesModule name)
            ];
            default = { };
            description = ''
              Defaults for all hosts.
              the modules passed under hostDefaults will be exported
              to the '${name}Modules' flake output.
              They will also be added to all hosts.
            '';
          };
          hosts = mkOption {
            type = attrsOf (submodule [ hostModule modulesModule ]);
            default = { };
            description = ''
              configurations to include in the ${name}Configurations output
            '';
          };
        };
      };

      # profiles and suites - which are profile collections
      profilesModule = { config, ... }: {
        options = with types; {
          profiles = mkOption {
            type = listOf path;
            default = [ ];
            description = ''
              profile folders that can be collected into suites
              the name of the argument passed to suites is based
              on the folder name.
              [ ./profiles ] => { profiles }:
            '';
          };
          suites = mkOption {
            type = pathTo (functionTo attrs);
            default = _: { };
            apply = suites: os.mkSuites {
              inherit suites;
              inherit (config) profiles;
            };
            description = ''
              Function that takes profiles and returns suites for this config system
              These can be accessed through the 'suites' special argument.
            '';
          };
        };
      };
    in
    {
      # this does not get propagated to submodules
      # to allow passing flake outputs directly to mkFlake
      config._module.check = false;

      options = with types; {
        self = mkOption {
          type = flakeType;
          description = "The flake to create the devos outputs for";
        };
        inputs = mkOption {
          type = attrsOf flakeType;
          description = ''
            inputs for this flake
            used to set channel defaults and create registry
          '';
        };
        supportedSystems = mkOption {
          type = listOf str;
          default = lib.defaultSystems;
          description = ''
            The systems supported by this flake
          '';
        };
        channelsConfig = mkOption {
          type = pathTo attrs;
          default = { };
          description = ''
            nixpkgs config for all channels
          '';
        };
        channels = mkOption {
          type = attrsOf (submodule channelsModule);
          default = { };
          description = ''
            nixpkgs channels to create
          '';
        };
        nixos = mkOption {
          type = submodule [ (includeHostsModule "nixos") profilesModule ];
          default = { };
          description = ''
            hosts, modules, suites, and profiles for nixos
          '';
        };
        home = mkOption {
          type = submodule [
            profilesModule
            (exportModulesModule "home")
            externalModulesModule
          ];
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

# constructor dependencies
{ lib, devshell, flake-utils, self, inputs, ... }:

with lib;

{ config, ... }:
let
  cfg = config;

  # #############
  # Resolver
  # #############

  /**
    Synopsis: maybeImport <path|string or obj>

    Returns an imported path or string or the object otherwise.

    Use when you want to allow specifying an object directly or a path to it.
    It saves the end user the additional import statement.
    **/
  maybeImport = obj:
    if (builtins.isPath obj || builtins.isString obj) then
      import obj
    else obj
  ;

  /**
    Synopsis: maybeImportDevshellToml <path|string or obj>

    Returns an imported path or string if the filename ends in `toml` or the object or path otherwise.

    Use only for devshell modules, as an apply function.
    **/
  maybeImportDevshellToml = obj:
    if ((builtins.isPath obj || builtins.isString obj) && lib.hasSuffix ".toml" obj) then
      devshell.lib.importTOML obj
    else obj
  ;

  /**
    Synopsis: pathToOr <type>

    Type resolver: types maybeImport's <obj>.

    Use in type declarations.
    **/
  pathToOr = elemType: with types; coercedTo path maybeImport elemType;

  /**
    Synopsis: coercedListOf <type>

    Type resolver & list flattner: flattens a (evtl. arbitrarily nested) list of type <type>.

    Use in type declarations.
    **/
  coercedListOf = elemType: with types;
    coercedTo anything (x: flatten (singleton x)) (listOf elemType);


  # #############
  # Custom Types
  # #############

  nixosTestType = pathToOr (mkOptionType {
    name = "test";
    check = x: builtins.isFunction x || builtins.isAttrs x;
    description = "valid NixOS test";
  });

  moduleType = mkOptionType {
    name = "module";
    inherit (types.submodule { }) check;
    description = "valid module";
  };

  devshellModuleType = with types; coercedTo path maybeImportDevshellToml moduleType;

  overlayType = pathToOr (mkOptionType {
    name = "overlay";
    check = builtins.isFunction;
    description = "valid Nixpkgs overlay";
  });

  systemType = (types.enum config.supportedSystems) // {
    description = "system defined in `supportedSystems`";
  };

  channelType = (types.enum (builtins.attrNames config.channels)) // {
    description = "channel defined in `channels`";
  };

  flakeType = with types; (addCheck attrs lib.isStorePath) // {
    description = "nix flake";
  };

  userType = with types; pathToOr moduleType // {
    description = "HM user config";
  };

  overlaysType = with types; coercedListOf overlayType;
  modulesType = with types; coercedListOf moduleType;
  nixosTestsType = with types; coercedListOf nixosTestType;
  devshellModulesType = with types; coercedListOf devshellModuleType;
  legacyProfilesType = with types; listOf path;
  legacySuitesType = with types; functionTo attrs;
  suitesType = with types; attrsOf (coercedListOf path);
  usersType = with types; attrsOf userType;
  inputsType = with types; attrsOf flakeType;

  # #############
  # Options
  # #############

  systemOpt = {
    system = mkOption {
      type = with types; nullOr systemType;
      default = null;
      description = ''
        system for this host
      '';
    };
  };

  channelNameOpt = required: {
    channelName = mkOption
      {
        description = ''
          Channel this host should follow
        '';
      }
    //
    (
      if required then {
        type = with types; channelType;
      } else {
        type = with types; nullOr channelType;
        default = null;
      }
    );
  };

  nixosTestOpt = {
    tests = mkOption {
      type = with types; nixosTestsType;
      default = [ ];
      description = ''
        tests to run
      '';
      example = literalExample ''
        [
          {
            name = "testname1";
            machine = { ... };
            testScript = '''
              # ...
            ''';
          }
          ({ corutils, writers, ... }: {
            name = "testname2";
            machine = { ... };
            testScript = '''
              # ...
            ''';
          })
          ./path/to/test.nix
        ];
      '';
    };
  };

  modulesOpt = {
    modules = mkOption {
      type = with types; pathToOr modulesType;
      default = [ ];
      description = ''
        modules to include
      '';
    };
  };

  exportedModulesOpt' = name: {
    type = with types; pathToOr modulesType;
    default = [ ];
    description = ''
      modules to include in all hosts and export to ${name}Modules output
    '';
  };

  exportedModulesOpt = name: { exportedModules = mkOption (exportedModulesOpt' name); };
  exportedDevshellModulesOpt = {
    exportedModules = mkOption (
      (exportedModulesOpt' "devshell") // {
        type = with types; devshellModulesType;
      }
    );
  };

  # This is only needed for hostDefaults
  # modules in each host don't get exported
  regularModulesOpt = {
    modules = mkOption {
      type = with types; pathToOr modulesType;
      default = [ ];
      description = ''
        modules to include that won't be exported
        meant importing modules from external flakes
      '';
    };
  };

  externalModulesDeprecationMessage = ''
    The `externalModules` option has been removed.
    Any modules that should be exported should be defined with the `exportedModules`
    option and all other modules should just go into the `modules` option.
  '';
  legacyExternalModulesMod = { config, options, ... }: {
    options = {
      externalModules = mkOption {
        type = with types; modulesType;
        default = [ ];
        description = externalModulesDeprecationMessage;
      };
    };
    config = mkIf (config.externalModules != [ ]) {
      modules = throw ''
        ERROR: ${externalModulesDeprecationMessage}
      '';
    };
  };

  hostDefaultsOpt = name: {
    hostDefaults = mkOption {
      type = with types; hostDefaultsType name;
      default = { };
      description = ''
        Defaults for all hosts.
        the modules passed under hostDefaults will be exported
        to the '${name}Modules' flake output.
        They will also be added to all hosts.
      '';
    };
  };

  hostsOpt = name: {
    hosts = mkOption {
      type = with types; hostType;
      default = { };
      description = ''
        configurations to include in the ${name}Configurations output
      '';
    };
  };

  inputOpt = name: {
    input = mkOption {
      type = flakeType;
      default = self.inputs.${name};
      defaultText = "self.inputs.<name>";
      description = ''
        nixpkgs flake input to use for this channel
      '';
    };
  };

  overlaysOpt = {
    overlays = mkOption {
      type = with types; pathToOr overlaysType;
      default = [ ];
      description = escape [ "<" ">" ] ''
        overlays to apply to this channel
        these will get exported under the 'overlays' flake output
        as <channel>/<name> and any overlay pulled from ''\${inputs}
        will be filtered out
      '';
    };
  };

  patchesOpt = {
    patches = mkOption {
      type = with types; listOf path;
      default = [ ];
      description = ''
        patches to apply to this channel
      '';
    };
  };

  configOpt = {
    config = mkOption {
      type = with types; pathToOr attrs;
      default = { };
      apply = lib.recursiveUpdate cfg.channelsConfig;
      description = ''
        nixpkgs config for this channel
      '';
    };
  };

  importablesOpt = {
    importables = mkOption {
      type = with types; submoduleWith {
        modules = [{
          freeformType = attrs;
          options = {
            suites = mkOption {
              type = nullOr (pathToOr suitesType);
              default = null;
              description = ''
                collections of profiles
              '';
            };
          };
        }];
      };
      default = { };
      description = ''
        Packages of paths to be passed to modules as `specialArgs`.
      '';
    };
  };

  usersOpt = {
    users = mkOption {
      type = with types; usersType;
      default = { };
      description = ''
        HM users that can be deployed portably without a host.
      '';
    };
  };

  # #############
  # Aggreagate types
  # #############

  hostType = with types; attrsOf (submoduleWith {
    modules = [
      # per-host modules not exported, no external modules
      { options = systemOpt // (channelNameOpt false) // modulesOpt // nixosTestOpt; }
    ];
  });

  hostDefaultsType = name: with types; submoduleWith {
    modules = [
      { options = systemOpt // (channelNameOpt true) // regularModulesOpt // (exportedModulesOpt name); }
      legacyExternalModulesMod
    ];
  };

  nixosType = with types; submoduleWith {
    specialArgs = { inherit self inputs; };
    modules = [
      { options = (hostsOpt "nixos") // (hostDefaultsOpt "nixos") // importablesOpt; }
    ];
  };

  homeType = with types; submoduleWith {
    specialArgs = { inherit self inputs; };
    modules = [
      { options = regularModulesOpt // (exportedModulesOpt "home") // importablesOpt // usersOpt; }
      legacyExternalModulesMod
    ];
  };

  devshellType = with types; submoduleWith {
    specialArgs = { inherit self inputs; };
    modules = [
      { options = regularModulesOpt // exportedDevshellModulesOpt; }
      legacyExternalModulesMod
    ];
  };

  channelsType = with types; attrsOf (submoduleWith {
    modules = [
      ({ name, ... }: { options = overlaysOpt // configOpt // (inputOpt name) // patchesOpt; })
    ];
  });

  outputsBuilderType = with types; functionTo attrs;

in
{
  # this does not get propagated to submodules
  # to allow passing flake outputs directly to mkFlake
  config._module.check = false;

  options = with types; {
    self = mkOption {
      type = flakeType;
      readOnly = true;
      description = "The flake to create the DevOS outputs for";
    };
    inputs = mkOption {
      type = inputsType;
      readOnly = true;
      description = "The flake's inputs";
    };
    supportedSystems = mkOption {
      type = listOf str;
      default = flake-utils.lib.defaultSystems;
      description = ''
        The systems supported by this flake
      '';
    };
    channelsConfig = mkOption {
      type = pathToOr attrs;
      default = { };
      description = ''
        nixpkgs config for all channels
      '';
    };
    channels = mkOption {
      type = pathToOr channelsType;
      default = { };
      description = ''
        nixpkgs channels to create
      '';
    };
    outputsBuilder = mkOption {
      type = pathToOr outputsBuilderType;
      default = channels: { };
      defaultText = "channels: { }";
      description = ''
        builder for flake system-spaced outputs
        The builder gets passed an attrset of all channels
      '';
    };
    nixos = mkOption {
      type = pathToOr nixosType;
      default = { };
      description = ''
        hosts, modules, suites, and profiles for NixOS
      '';
    };
    home = mkOption {
      type = pathToOr homeType;
      default = { };
      description = ''
        hosts, modules, suites, and profiles for home-manager
      '';
    };
    devshell = mkOption {
      type = pathToOr devshellType;
      default = { };
      description = ''
        Modules to include in your DevOS shell. the `modules` argument
        will be exported under the `devshellModules` output
      '';
    };
  };
}

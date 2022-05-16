# constructor dependencies
{ lib, devshell, flake-utils, self, inputs, ... }:

with lib;

{ config, ... }:
let
  cfg = config;

  #============
  # Resolvers
  #============

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


  #================
  # Custom Types
  #================

  nixosTestType = pathToOr (mkOptionType {
    name = "test";
    check = x: builtins.isFunction x || builtins.isAttrs x;
    description = "Valid NixOS test";
  });

  moduleType = mkOptionType {
    name = "module";
    inherit (types.submodule { }) check;
    description = "Valid module";
  };

  devshellModuleType = with types; coercedTo path maybeImportDevshellToml moduleType;

  overlayType = pathToOr (mkOptionType {
    name = "overlay";
    check = builtins.isFunction;
    description = "Valid channel overlay";
  });

  systemType = (types.enum config.supportedSystems) // {
    description = "One of the systems defined in `supportedSystems`";
  };

  channelType = (types.enum (builtins.attrNames config.channels)) // {
    description = "One of the channels defined in `channels`";
  };

  # TODO: does checking whether an attrset exists in the store indicate that the
  # attrset is a flake?
  flakeType = with types; (addCheck attrs lib.isStorePath) // {
    description = "Valid flake";
  };

  overlaysType = with types; coercedListOf overlayType;
  modulesType = with types; coercedListOf moduleType;
  nixosTestsType = with types; coercedListOf nixosTestType;
  devshellModulesType = with types; coercedListOf devshellModuleType;
  legacyProfilesType = with types; listOf path;
  legacySuitesType = with types; functionTo attrs;
  suitesType = with types; attrsOf (coercedListOf path);
  inputsType = with types; attrsOf flakeType;
  usersType = with types; attrsOf (pathToOr moduleType // {
    description = "HM user config";
  });

  #===========
  # Options
  #===========

  systemOpt = {
    system = mkOption {
      type = with types; nullOr systemType;
      default = null;
      description = ''
        System for this host.
      '';
    };
  };

  channelNameOpt = required: {
    channelName = mkOption
      {
        description = ''
          Channel this host should follow.
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
        Tests to run for this host.
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
        Modules to include for this specific host only.
      '';
    };
  };

  exportedModulesOpt' = name: {
    type = with types; pathToOr modulesType;
    default = [ ];
    description = ''
      Modules to include and export to the ${name}Modules flake output.
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

  regularModulesOpt = {
    modules = mkOption {
      type = with types; pathToOr modulesType;
      default = [ ];
      description = ''
        Default modules to import for all hosts.

        These modules will not be exported via flake outputs.
        Primarily useful for importing modules from external flakes.
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
      '';
    };
  };

  hostsOpt = name: {
    hosts = mkOption {
      type = with types; hostType;
      default = { };
      description = ''
        Configurations to export via the ${name}Configurations flake output.
      '';
    };
  };

  inputOpt = name: {
    input = mkOption {
      type = flakeType;
      default = self.inputs.${name};
      defaultText = "self.inputs.<name>";
      description = ''
        Nixpkgs flake input to use for this channel.
      '';
    };
  };

  overlaysOpt = {
    overlays = mkOption {
      type = with types; pathToOr overlaysType;
      default = [ ];
      description = escape [ "<" ">" ] ''
        Overlays to apply to this channel and export via the 'overlays' flake output.

        The attributes in the 'overlays' output will be named following the
        '<channel>/<name>' format.

        Any overlay pulled from <inputs> will not be exported.
      '';
    };
  };

  patchesOpt = {
    patches = mkOption {
      type = with types; listOf path;
      default = [ ];
      description = ''
        Patches to apply to this channel.
      '';
    };
  };

  configOpt = {
    config = mkOption {
      type = with types; pathToOr attrs;
      default = { };
      apply = lib.recursiveUpdate cfg.channelsConfig;
      description = ''
        Nixpkgs config for this channel.
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
                Collections of profiles.
              '';
            };
          };
        }];
      };
      default = { };
      description = ''
        Packages of paths to be passed to modules as additional args.
      '';
    };
  };

  usersOpt = {
    users = mkOption {
      type = with types; usersType;
      default = { };
      description = ''
        home-manager users that can be deployed portably to any host.

        These configurations must work on *all* supported systems.

        Generic Linux systems only support these portable home-manager
        configurations. They cannot be configured as hosts like NixOS or
        nix-darwin systems.
      '';
    };
  };

  #==================
  # Composite Types
  #==================

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

  darwinType = with types; submoduleWith {
    specialArgs = { inherit self inputs; };
    modules = [
      { options = (hostsOpt "darwin") // (hostDefaultsOpt "darwin") // importablesOpt; }
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
  # Allow passing flake outputs directly to `mkFlake`.
  #
  # This does not get propagated to submodules.
  config._module.check = false;

  options = with types; {
    self = mkOption {
      type = flakeType;
      readOnly = true;
      description = "The flake itself.";
    };
    inputs = mkOption {
      type = inputsType;
      readOnly = true;
      description = "The flake's inputs.";
    };
    supportedSystems = mkOption {
      type = listOf str;
      default = flake-utils.lib.defaultSystems;
      description = ''
        The systems supported by this flake.
      '';
    };
    channelsConfig = mkOption {
      type = pathToOr attrs;
      default = { };
      description = ''
        Nixpkgs configuration shared between all channels.
      '';
    };
    channels = mkOption {
      type = pathToOr channelsType;
      default = { };
      description = ''
        Nixpkgs channels to create.
      '';
    };
    outputsBuilder = mkOption {
      type = pathToOr outputsBuilderType;
      default = channels: { };
      defaultText = "channels: { }";
      description = ''
        Builder for flake system-spaced outputs.
      '';
    };
    nixos = mkOption {
      type = pathToOr nixosType;
      default = { };
      description = ''
        NixOS host configurations.
      '';
    };
    darwin = mkOption {
      type = pathToOr darwinType;
      default = { };
      description = ''
        Darwin host configurations.
      '';
    };
    home = mkOption {
      type = pathToOr homeType;
      default = { };
      description = ''
        home-manager user configurations.
      '';
    };
    devshell = mkOption {
      type = pathToOr devshellType;
      default = { };
      description = ''
        Modules to include in our development shell.
      '';
    };
  };
}

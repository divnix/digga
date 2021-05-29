{ lib }:

{ args }:
let
  argOpts = with lib; { config, ... }:
    let
      cfg = config;
      inherit (config) self;

      maybeImport = obj:
        if (builtins.isPath obj || builtins.isString obj) && lib.hasSuffix ".nix" obj then
          import obj
        else
          obj;

      /* Custom types needed for arguments */

      moduleType = with types; pathTo (anything // {
        inherit (submodule { }) check;
        description = "valid module";
      });

      # to export modules we need paths to get the name
      exportModuleType = with types;
        (addCheck path (x: moduleType.check (maybeImport x))) // {
          description = "path to a module";
        };
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

      coercedListOf = elemType: with types;
        coercedTo anything (x: flatten (singleton x)) (listOf elemType);

      /* Submodules needed for API containers */

      channelsModule = { name, ... }: {
        options = with types; {
          input = mkOption {
            type = flakeType;
            default = cfg.inputs.${name};
            defaultText = "inputs.<name>";
            description = ''
              nixpkgs flake input to use for this channel
            '';
          };
          overlays = mkOption {
            type = coercedListOf overlayType;
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
            type = with types; coercedListOf moduleType;
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
            type = with types; pathTo (coercedListOf exportModuleType);
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

      suitesDeprecationMessage = ''
        WARNING: The 'suites' and `profiles` options have been deprecated, you can now create
        both with the importables option. `rakeLeaves` can be used to create profiles and
        by passing a module or `rec` set to `importables`, suites can access profiles.
        Example:
        ```
        importables = rec {
          profiles = digga.lib.importers.rakeLeaves ./profiles;
          suites = with profiles; { };
        }
        ```
        See https://github.com/divnix/digga/pull/30 for more details
      '';
      importablesModule = { config, options, ... }: {
        config = {
          importables = mkIf options.suites.isDefined {
            suites = builtins.trace suitesDeprecationMessage config.suites;
          };
        };
        options = with types; {
          profiles = mkOption {
            type = listOf path;
            default = [ ];
            description = suitesDeprecationMessage;
          };
          suites = mkOption {
            type = pathTo (functionTo attrs);
            apply = suites: lib.mkSuites {
              inherit suites;
              inherit (config) profiles;
            };
            description = suitesDeprecationMessage;
          };
          importables = mkOption {
            type = submoduleWith {
              modules = [{
                freeformType = attrs;
                options = {
                  suites = mkOption {
                    type = attrsOf (coercedListOf path);
                    # add `allProfiles` to it here
                    apply = suites: suites // {
                      allProfiles = lib.foldl
                        (lhs: rhs: lhs ++ rhs) [ ]
                        (builtins.attrValues suites);
                    };
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
          type = attrsOf (submoduleWith {
            modules = [ channelsModule ];
          });
          default = { };
          description = ''
            nixpkgs channels to create
          '';
        };
        outputsBuilder = mkOption {
          type = functionTo attrs;
          default = channels: { };
          defaultText = "channels: { }";
          description = ''
            builder for flake system-spaced outputs
            The builder gets passed an attrset of all channels
          '';
        };
        nixos = mkOption {
          type = submoduleWith {
            # allows easy use of the `imports` key
            modules = [ (includeHostsModule "nixos") importablesModule ];
          };
          default = { };
          description = ''
            hosts, modules, suites, and profiles for nixos
          '';
        };
        home = mkOption {
          type = submoduleWith {
            # allows easy use of the `imports` key
            modules = [
              importablesModule
              (exportModulesModule "home")
              externalModulesModule
            ];
          };
          default = { };
          description = ''
            hosts, modules, suites, and profiles for home-manager
          '';
        };
        devshell = mkOption {
          type = submoduleWith {
            modules = [
              (exportModulesModule "devshell")
              externalModulesModule
            ];
          };
          default = { };
          description = ''
            Modules to include in your devos shell. the `modules` argument
            will be exported under the `devshellModules` output
          '';
        };
      };
    };
in
lib.evalModules {
  modules = [ argOpts args ];
}

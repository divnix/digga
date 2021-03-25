{ self, dev, nixos, inputs, ... }:

{ args }:
let
  argOpts = with nixos.lib; { config, options, ... }:
    let
      inherit (dev) os;
      inherit (os) importIf;

      cfg = config;
      inherit (cfg) self;

      inputAttrs = types.functionTo types.attrs;
    in
    {
      options = with types; {
        self = mkOption {
          type = addCheck attrs nixos.lib.isStorePath;
          description = "The flake to create the devos outputs for";
        };
        hosts = mkOption {
          type = path;
          default = "${self}/hosts";
          defaultText = "\${self}/hosts";
          description = "Path to directory containing host configurations";
        };
        packages = mkOption {
          # functionTo changes arg names which breaks flake check
          type = types.anything // {
            check = builtins.isFunction;
            description = "Nixpkgs overlay";
          };
          default = importIf "${self}/pkgs" (final: prev: {});
          defaultText = "\${self}/pkgs";
          description = ''
            Overlay for custom packages that will be included in treewide 'pkgs'.
            This should follow the standard nixpkgs overlay format - two argument function
            that returns an attrset.
          '';
        };
        modules = mkOption {
          type = listOf anything;
          default = importIf "${self}/modules/module-list.nix" [];
          defaultText = "\${self}/modules/module-list.nix";
          apply = dev.pathsToImportedAttrs;
          description = "list of modules to include in confgurations";
        };
        userModules = mkOption {
          type = listOf anything;
          default = importIf "${self}/users/modules/module-list.nix" [];
          defaultText = "\${self}/users/modules/module-list.nix";
          apply = dev.pathsToImportedAttrs;
          description = "list of modules to include in home-manager configurations";
        };
        profiles = mkOption {
          type = path;
          default = "${self}/profiles";
          defaultText = "\${self}/profiles";
          apply = os.mkProfileAttrs;
          description = "path to profiles folder";
        };
        userProfiles = mkOption {
          type = path;
          default = "${self}/users/profiles";
          defaultText = "\${self}/users/profiles";
          apply = os.mkProfileAttrs;
          description = "path to user profiles folder";
        };
        suites =
          let
            defaults = { user = {}; system = {}; };
          in
          mkOption {
            type = inputAttrs;
            default = importIf "${self}/suites" ({...}: defaults);
            defaultText = "\${self}/suites";
            apply = suites: defaults // os.mkSuites {
              inherit suites;
              inherit (config) profiles users userProfiles;
            };
            description = ''
              function with inputs 'users' and 'profiles' that returns attribute 'system'
              which defines suites passed to configurations as the suites specialArg
            '';
          };
        users = mkOption {
          type = path;
          default = "${self}/users";
          defaultText = "\${self}/users";
          apply = os.mkProfileAttrs;
          description = "path to folder containing user profiles";
        };
        extern =
          let
            defaults = {
              modules = []; overlays = []; specialArgs = {};
              userModules = []; userSpecialArgs = [];
            };
          in
          mkOption {
            type = inputAttrs;
            default = importIf "${self}/extern" ({...}: defaults);
            defaultText = "\${self}/extern";
            # So unneeded extern attributes can safely be deleted
            apply = x: defaults // (x { inputs = inputs // self.inputs; });
            description = ''
              Function with argument 'inputs' with all devos and this flake's inputs.
              The function should return an attribute set with modules, overlays, and
              specialArgs to be included across devos
            '';
          };
        overlays = mkOption {
          type = path;
          default = "${self}/overlays";
          defaultText = "\${self}/overlays";
          apply = x: dev.pathsToImportedAttrs (dev.pathsIn x);
          description = "path to folder containing overlays which will be applied to pkgs";
        };
        overrides =
          let
            defaults = { modules = []; disabledModules = []; packages = _: _: _: {}; };
          in
          mkOption {
            type = attrs;
            default = importIf "${self}/overrides" defaults;
            apply = x: defaults // x;
            defaultText = "\${self}/overrides";
            description = "attrset of packages and modules that will be pulled from nixpkgs master";
          };
        genDoc = mkOption {
          type = functionTo attrs;
          internal = true;
          description = "function that returns a generated options doc derivation given nixpkgs";
        };
      };
      config.genDoc =
        let
          singleDoc = name: value: ''
            ## ${name}
            ${value.description}

            ${optionalString (value ? type) ''
              *_Type_*:
              ${value.type}
            ''}
            ${optionalString (value ? default) ''
              *_Default_*
              ```
              ${builtins.toJSON value.default}
              ```
            ''}
            ${optionalString (value ? example) ''
              *_Example_*
              ```
              ${value.example}
              ```
            ''}
          '';
        in
          pkgs: with pkgs; writeText "devosOptions.md"
            (concatStringsSep "" (mapAttrsToList singleDoc (nixosOptionsDoc { inherit options; }).optionsNix));
    };
in
  nixos.lib.evalModules {
    modules = [ argOpts args ];
  }

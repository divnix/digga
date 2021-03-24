{ self, dev, nixos, inputs, ... }:

{ args }:
let
  argOpts = with nixos.lib; { config, options, ... }:
    let
      inherit (dev) os;
      inherit (os) importIf;

      cfg = config;
      inherit (cfg) self;

      pathOr = x: with types; oneOf [ path x ];
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
          type = pathOr (functionTo inputAttrs);
          default = "${self}/pkgs";
          defaultText = "\${self}/pkgs";
          apply = importIf;
          description = ''
            Overlay for custom packages that will be included in treewide 'pkgs'.
            This should follow the standard nixpkgs overlay format - two argument function
            that returns an attrset.
          '';
        };
        modules = mkOption {
          default = "${self}/modules/module-list.nix";
          defaultText = "\${self}/modules/module-list.nix";
          type = pathOr (listOf anything);
          apply = x: dev.pathsToImportedAttrs (importIf x);
          description = "list of modules to include in confgurations";
        };
        userModules = mkOption {
          default = "${self}/users/modules/module-list.nix";
          defaultText = "\${self}/users/modules/module-list.nix";
          type = pathOr (listOf anything);
          apply = x: dev.pathsToImportedAttrs (importIf x);
          description = "list of modules to include in home-manager configurations";
        };
        profiles = mkOption {
          type = path;
          default = "${self}/profiles";
          defaultText = "\${self}/profiles";
          description = "path to profiles folder";
        };
        userProfiles = mkOption {
          type = path;
          default = "${self}/users/profiles";
          defaultText = "\${self}/users/profiles";
          description = "path to user profiles folder";
        };
        suites = mkOption {
          type = pathOr inputAttrs;
          default = "${self}/suites";
          defaultText = "\${self}/suites";
          apply = x: os.mkSuites {
            inherit (config) profiles users userProfiles;
            suites = importIf x;
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
          description = "path to folder containing user profiles";
        };
        extern = mkOption {
          type = pathOr inputAttrs;
          default = "${self}/extern";
          defaultText = "\${self}/extern";
          apply = x: (importIf x) { inputs = inputs // self.inputs; };
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
        overrides = mkOption {
          type = pathOr attrs;
          default = "${self}/overrides";
          defaultText = "\${self}/overrides";
          apply = importIf;
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

            ${optionalString (hasAttr "type" value ) ''
              *_Type_*:
              ${value.type}
            ''}
            ${optionalString (hasAttr "default" value) ''
              *_Default_*
              ```
              ${builtins.toJSON value.default or ""}
              ```
            ''}
            ${optionalString (hasAttr "example" value) ''
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

{ lib, deploy, devshell, home-manager }:
let
  inherit (builtins) mapAttrs attrNames attrValues head isFunction;
in

_: { self, ... } @ args:
let

  evaled = lib.mkFlake.evalArgs {
    inherit args;
  };

  cfg = evaled.config;

  otherArguments = removeAttrs args (attrNames evaled.options);

  defaultHostModules = [
    (lib.modules.hmNixosDefaults {
      specialArgs = cfg.home.importables;
      modules = cfg.home.modules ++ cfg.home.externalModules;
    })
    (lib.modules.globalDefaults {
      inherit self;
      hmUsers = cfg.home.users;
    })
    ({ ... }@args: {
      lib.specialArgs = args.specialArgs or (builtins.trace ''
        WARNING: specialArgs is not accessibly by the module system which means you
        are likely using NixOS 20.09. Profiles testing and custom builds (ex: iso)
        are not supported in 20.09 and using them could result in infinite
        recursion errors. It is recommended to update to 21.05 to use either feature.
      ''
        { });
    })
    lib.modules.customBuilds
  ];

  unifyOverlays = channels: map (o: if builtins.isFunction (o null null) then o channels else o);

  stripChannel = channel: removeAttrs channel [
    # arguments in our channels api that shouldn't be passed to fup
    "overlays"
  ];

  # evalArgs sets channelName and system to null by default
  # but for proper default handling in fup, null args have to be removed
  stripHost = args: removeAttrs (lib.filterAttrs (_: arg: arg != null) args) [
    # arguments in our hosts/hostDefaults api that shouldn't be passed to fup
    "externalModules"
  ];

  mkPortableHomeManagerConfiguration =
    { username
    , configuration
    , pkgs
    , system ? pkgs.system
    }:
    let
      homeDirectoryPrefix =
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      homeDirectory = "${homeDirectoryPrefix}/${username}";
    in
    home-manager.lib.homeManagerConfiguration {
      inherit username homeDirectory pkgs system;

      extraModules = cfg.home.modules ++ cfg.home.externalModules;
      extraSpecialArgs = cfg.home.importables;

      configuration = {
        imports = [ configuration ];
      } // (
        if pkgs.stdenv.hostPlatform.isLinux
        then { targets.genericLinux.enable = true; }
        else { }
      );
    };

in
lib.systemFlake (lib.mergeAny
  {
    inherit self;
    inherit (self) inputs;
    inherit (cfg) channelsConfig supportedSystems;

    hosts = lib.mapAttrs (_: stripHost) cfg.nixos.hosts;

    channels = mapAttrs
      (name: channel:
        stripChannel (channel // {
          # pass channels if "overlay" has three arguments
          overlaysBuilder = channels: unifyOverlays channels channel.overlays;
        })
      )
      cfg.channels;

    sharedOverlays = [
      (final: prev: {
        __dontExport = true;
        lib = prev.lib.extend (lfinal: lprev: {
          # digga lib can be accessed in packages as lib.digga
          digga = lib;
        });
      })
    ];

    hostDefaults = lib.mergeAny (stripHost cfg.nixos.hostDefaults) {
      specialArgs = cfg.nixos.importables;
      modules = cfg.nixos.hostDefaults.externalModules ++ defaultHostModules;
    };

    nixosModules = lib.exporters.modulesFromList cfg.nixos.hostDefaults.modules;

    homeModules = lib.exporters.modulesFromList cfg.home.modules;

    devshellModules = lib.exporters.modulesFromList cfg.devshell.modules;

    overlays = lib.exporters.internalOverlays {
      # since we can't detect overlays owned by self
      # we have to filter out ones exported by the inputs
      # optimally we would want a solution for NixOS/nix#4740
      inherit (self) pkgs inputs;
    };

    outputsBuilder = channels:
      let
        pkgs = channels.${cfg.nixos.hostDefaults.channelName};
        system = pkgs.system;

        homeConfigurationsPortable =
          builtins.mapAttrs
            (n: v: mkPortableHomeManagerConfiguration {
              username = n;
              configuration = v;
              inherit pkgs system;
            })
            cfg.home.users;

        defaultOutputsBuilder = {

          inherit homeConfigurationsPortable;

          packages = lib.exporters.fromOverlays self.overlays channels;

          checks =
            ( # for self.homeConfigurations if present & non empty
              if (
                (builtins.hasAttr "homeConfigurations" self) &&
                (self.homeConfigurations != { })
              ) then
                let
                  collectActivationPackages = n: v: {name = "user-" + n; value = v.activationPackage; };
                in lib.mapAttrs' collectActivationPackages self.homeConfigurations
              else { }
            )
            //
            ( # for portableHomeConfigurations if present & non empty
              if (
                (homeConfigurationsPortable != { })
              ) then
                let
                  collectActivationPackages = n: v: {name = "user-" + n; value = v.activationPackage; };
                in lib.mapAttrs' collectActivationPackages homeConfigurationsPortable
              else { }
            )
            //
            ( # for self.deploy if present & non-empty
              if (
                (builtins.hasAttr "deploy" self) &&
                (self.deploy != { })
              ) then
                let
                  deployChecks = deploy.lib.${system}.deployChecks self.deploy;
                  renameOp = n: v: {name = "deploy-" + n; value = deployChecks.${n}; };
                in lib.mapAttrs' renameOp deployChecks
              else {}
            )
            //
            ( # for self.nixosConfigurations if present & non-empty
              if (
                (builtins.hasAttr "nixosConfigurations" self) &&
                (self.nixosConfigurations != { })
              ) then
                let
                  systemSieve = _: host: host.config.nixpkgs.system == system;
                  hostConfigsOnThisSystem = lib.filterAttrs systemSieve self.nixosConfigurations;

                  suitesSieve = n: host:
                    lib.warnIf (host.config.lib.specialArgs.suites == null) ''
                      '${n}' will only be tested against all profiles if 'importables.suites'
                      are used to declare your profiles.
                    ''
                    host.config.lib.specialArgs.suites != null;
                  hostConfigsOnThisSystemWithSuites = lib.filterAttrs suitesSieve hostConfigsOnThisSystem;

                  createProfilesTestOp = n: host: {
                    name = "allProfilesTestFor-${n}";
                    value = lib.tests.profilesTest {
                      inherit host pkgs;
                    };
                  };

                  profilesTests =
                    # only for hosts that also are the same system as the current check attribute
                    if (hostConfigsOnThisSystem != [ ])
                    then lib.mapAttrs' createProfilesTestOp hostConfigsOnThisSystemWithSuites
                    else { };

                in profilesTests
              else { }
            )
          ;

          devShell = (import devshell { inherit system pkgs; }).mkShell {
            name = lib.mkDefault cfg.nixos.hostDefaults.channelName;
            imports = cfg.devshell.modules ++ cfg.devshell.externalModules;
          };

        };

      in
      lib.mergeAny defaultOutputsBuilder (cfg.outputsBuilder channels);

  }
  otherArguments # for overlays list order
)

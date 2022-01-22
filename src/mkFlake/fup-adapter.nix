# constructor dependencies
{ lib, self, inputs, darwin, flake-utils-plus, internal-modules, ... }:

{
  # evaluated digga configuration
  config
  # extra arguments that are passed down to fup
, extraArgs
  # pass a custom default fup outputs builder
, defaultOutputsBuilder
}:

let

  sharedOverlays = [
    (final: prev: {
      __dontExport = true;
      lib = prev.lib.extend (lfinal: lprev: {
        # digga lib can be accessed in packages as lib.digga
        digga = lib;
      });
    })
  ];

  defaultHostModules = [
    (internal-modules.hmNixosDefaults {
      specialArgs = config.home.importables // { inherit self inputs; };
      modules = config.home.modules ++ config.home.exportedModules;
    })
    (internal-modules.globalDefaults {
      hmUsers = config.home.users;
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
    "externalModules" # TODO: remove deprecated option
    "exportedModules"
    "tests"
  ];

  diggaFupArgs = {
    inherit (config)
      channelsConfig
      supportedSystems;
    inherit self inputs sharedOverlays;

    hosts = builtins.mapAttrs (_: stripHost) config.nixos.hosts;

    channels = builtins.mapAttrs
      (name: channel:
        stripChannel (channel // {
          # pass channels if "overlay" has three arguments
          overlaysBuilder = channels: unifyOverlays channels channel.overlays;
        })
      )
      config.channels;

    hostDefaults = flake-utils-plus.lib.mergeAny (stripHost config.nixos.hostDefaults) {
      # add `self` & `inputs` as specialargs so their libs can be used in imports
      specialArgs = config.nixos.importables // { inherit self inputs; };
      modules = config.nixos.hostDefaults.exportedModules ++ defaultHostModules;
    };

    nixosModules = flake-utils-plus.lib.exportModules config.nixos.hostDefaults.exportedModules;

    homeModules = flake-utils-plus.lib.exportModules config.home.exportedModules;

    devshellModules = flake-utils-plus.lib.exportModules config.devshell.exportedModules;

    overlays = flake-utils-plus.lib.exportOverlays {
      # since we can't detect overlays owned by self
      # we have to filter out ones exported by the inputs
      # optimally we would want a solution for NixOS/nix#4740
      inherit (self) pkgs;
      inherit inputs;
    };

    outputsBuilder = channels:
      flake-utils-plus.lib.mergeAny (defaultOutputsBuilder channels) (config.outputsBuilder channels);

  };

in
flake-utils-plus.lib.mkFlake
  (
    flake-utils-plus.lib.mergeAny
      diggaFupArgs
      extraArgs # for overlays list order
  )

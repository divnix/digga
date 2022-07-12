{ lib }:
{
  hmNixosDefaults = { specialArgs, modules }:
    { options, ... }: {
      config = lib.optionalAttrs (options ? home-manager) {
        home-manager = {
          # always use the system nixpkgs from the host's channel
          useGlobalPkgs = true;
          # and use the possible future default (see manual)
          useUserPackages = lib.mkDefault true;

          extraSpecialArgs = specialArgs;
          sharedModules = modules;
        };
      };
    };

  globalDefaults = { hmUsers }:
    { config, pkgs, self, ... }: {
      # Digga's library functions can be accessed directly through the module
      # system as `config.lib.digga`.
      lib = {
        inherit (pkgs.lib) digga;
      };

      _module.args = {
        inherit hmUsers;
        hosts = throw ''
          The `hosts` module argument has been removed, you should instead use
          `self.nixosConfigurations`, with the `self` module argument.
        '';
      };
    };

  nixosDefaults = { self, ... }: {
    # N.B. If users are not explicitly defined in configuration, they will be
    # removed from the resulting system. This could result in data loss if
    # you're not starting from a fresh install -- even if you are currently
    # logged in!
    users.mutableUsers = lib.mkDefault false;
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    system.configurationRevision = lib.mkIf (self ? rev) self.rev;
  };

}

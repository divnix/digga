{lib}: {
  hmNixosDefaults = {
    specialArgs,
    modules,
  }: {options, ...}: {
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

  globalDefaults = {hmUsers}: {
    config,
    pkgs,
    self,
    ...
  }: {
    users.mutableUsers = lib.mkDefault false;

    hardware.enableRedistributableFirmware = lib.mkDefault true;

    # digga lib can be accessed in modules directly as config.lib.digga
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

    system.configurationRevision = lib.mkIf (self ? rev) self.rev;
  };
}

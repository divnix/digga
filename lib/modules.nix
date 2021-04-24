{ lib }:
{
  modOverrides = { overrides }:
    { config, overrideModulesPath, ... }:
    let
      inherit (overrides) modules disabledModules;
    in
    {
      disabledModules = modules ++ disabledModules;
      imports = map
        (path: "${overrideModulesPath}/${path}")
        modules;
    };

  hmDefaults = { userSuites, extern, homeModules }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = extern.userSpecialArgs // { suites = userSuites; };
      sharedModules = extern.userModules ++ (builtins.attrValues homeModules);
    };
  };

  globalDefaults = { self, nixos, inputs, multiPkgs }:
    let
      experimentalFeatures = [
        "flakes"
        "nix-command"
        "ca-references"
        "ca-derivations"
      ];
    in
    { config, pkgs, ... }: {
      users.mutableUsers = lib.mkDefault false;

      hardware.enableRedistributableFirmware = lib.mkDefault true;

      nix.nixPath = [
        "nixpkgs=${nixos}"
        "nixos-config=${self}/lib/compat/nixos"
        "home-manager=${inputs.home}"
      ];

      nixpkgs.pkgs = lib.mkDefault multiPkgs.${config.nixpkgs.system};

      nix.registry = {
        devos.flake = self;
        nixos.flake = nixos;
        override.flake = inputs.override;
      };

      nix.package = pkgs.nixFlakes;

      nix.extraOptions = ''
        experimental-features = ${lib.concatStringsSep " "
          experimentalFeatures
        }
      '';

      system.configurationRevision = lib.mkIf (self ? rev) self.rev;
    };

  cachix = { self }:
    let rootCachix = "${self}/cachix.nix"; in
    if builtins.pathExists rootCachix
    then rootCachix
    else { };

  flakeModules = { self, extern }: { imports = builtins.attrValues self.nixosModules ++ extern.modules; };


}


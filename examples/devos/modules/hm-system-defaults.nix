{
  config,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    {
      home.sessionVariables = {
        # environment.sessionVariables is not currently available in nix-darwin
        NIX_PATH =
          config.environment.sessionVariables.NIX_PATH
          or config.environment.variables.NIX_PATH;
      };
      xdg.configFile."nix/registry.json".text =
        config.environment.etc."nix/registry.json".text;
    }
  ];
}

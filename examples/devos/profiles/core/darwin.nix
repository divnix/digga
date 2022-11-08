{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
  ];

  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;

  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  environment = {
    systemPackages = with pkgs; [
      m-cli
      terminal-notifier
    ];

    darwinConfig = "${self}/lib/compat";

    shellAliases = {
      nrb = "sudo darwin-rebuild switch --flake";
    };
  };

  nix = {
    nixPath = [
      # TODO: This entry should be added automatically via FUP's
      # `nix.linkInputs` and `nix.generateNixPathFromInputs` options, but
      # currently that doesn't work because nix-darwin doesn't export packages,
      # which FUP expects.
      #
      # This entry should be removed once the upstream issues are fixed.
      #
      # https://github.com/LnL7/nix-darwin/issues/277
      # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/107
      "darwin=/etc/nix/inputs/darwin"
    ];

    # Administrative users on Darwin are part of this group.
    trustedUsers = ["@admin"];
  };

  programs.bash = {
    # nix-darwin's shell options are very different from those on nixos. there
    # is no `promptInit` option, for example. so instead, we throw the prompt
    # init line into `interactiveShellInit`.
    #
    # https://github.com/LnL7/nix-darwin/blob/master/modules/programs/bash/default.nix
    interactiveShellInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };
}

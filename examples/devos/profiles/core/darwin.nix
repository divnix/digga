{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;

  # TODO: is there any way to check whether the system is using the daemon? or should these defs be excluded from devos?
  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  environment = {

    # FIXME: any more darwin essentials to add here?
    systemPackages = with pkgs; [
      m-cli
      terminal-notifier
    ];

    # FIXME: use devos path
    # environment.darwinConfig = "$DOTFIELD_DIR/lib/compat/darwin";

    shellAliases = {
      # nix
      # FIXME: does this need special args for darwin compat?
      nrb = "sudo darwin-rebuild";
    };

  };

  nix = {

    nixPath = [
      # FIXME: This entry should be added automatically via FUP's `nix.linkInputs`
      # and `nix.generateNixPathFromInputs` options, but currently that doesn't
      # work because nix-darwin doesn't export packages, which FUP expects.
      #
      # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/107
      "darwin=/etc/nix/inputs/darwin"
    ];

    # Administrative users on Darwin are part of this group.
    trustedUsers = [ "@admin" ];

  };

  programs.bash = {
    # nix-darwin's shell options are very different from those on nixos. there
    # is no `promptInit` option, for example. so instead, we throw the prompt
    # init line into `interactiveShellInit`.
    # https://github.com/LnL7/nix-darwin/blob/master/modules/programs/bash/default.nix
    interactiveShellInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  # FIXME: is homebrew absolutely necessary for a reasonable UX? if not, then remove.
  # homebrew = {
  #   # enable = true;
  #   enable = false;
  #   autoUpdate = true;
  #   global.noLock = true;
  # };

}

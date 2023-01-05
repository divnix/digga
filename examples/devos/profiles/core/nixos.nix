{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./common.nix
  ];

  environment = {
    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      dosfstools
      gptfdisk
      iputils
      usbutils
      utillinux
    ];

    shellAliases = let
      ifSudo = lib.mkIf config.security.sudo.enable;
    in {
      # nix
      nrb = ifSudo "sudo nixos-rebuild";

      # fix nixos-option for flake compat
      nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

      # systemd
      ctl = "systemctl";
      stl = ifSudo "s systemctl";
      utl = "systemctl --user";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      up = ifSudo "s systemctl start";
      dn = ifSudo "s systemctl stop";
      jtl = "journalctl";
    };
  };

  fonts.fontconfig.defaultFonts = {
    monospace = ["DejaVu Sans Mono for Powerline"];
    sansSerif = ["DejaVu Sans"];
  };

  nix = {
    settings = {
      # Prevent impurities in builds
      sandbox = true;

      # Give root user and wheel group special Nix privileges.
      trusted-users = ["root" "@wheel"];
      allowed-users = ["@wheel"];
    };

    # Improve nix store disk usage
    settings.auto-optimise-store = true;
    optimise.automatic = true;
  };

  programs.bash = {
    # Enable starship
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';

    # Enable direnv, a tool for managing shell environments
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  # Service that makes Out of Memory Killer more effective
  services.earlyoom.enable = true;
}

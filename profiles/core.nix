{ config, lib, pkgs, ... }:
let
  inherit (lib)
    fileContents
    ;

in
{

  imports = [
    ../local/locale.nix
    ../local/file-systems.nix
  ];


  boot = {

    kernelPackages = pkgs.linuxPackages_latest;

    tmpOnTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;

  };


  environment = {

    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      dnsutils
      fd
      git
      iputils
      manpages
      moreutils
      ripgrep
      stdmanpages
      utillinux
    ];

    shellAliases = let
      ifSudo = string: lib.mkIf config.security.sudo.enable string;
    in
      {
        # quick cd
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # git
        g = "git";

        # grep
        grep = "rg";
        gi = "grep -i";

        # internet ip
        myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

        # nix
        n = "nix";
        ni = "n profile install";
        nrb = ifSudo "sudo nixos-rebuild";

        # sudo
        si = ifSudo "env sudo -i";
        sudo = ifSudo "sudo -E ";
        se = ifSudo "sudoedit";

        # systemd
        ctl = "systemctl";
        stl = ifSudo "sudo systemctl";
        utl = "systemctl --user";
        ut = "systemctl --user start";
        un = "systemctl --user stop";
        up = ifSudo "sudo systemctl start";
        dn = ifSudo "sudo systemctl stop";
        jctl = "journalctl";

      };

  };


  fonts = {
    fonts = with pkgs; [
      powerline-fonts
      dejavu_fonts
    ];


    fontconfig.defaultFonts = {

      monospace = [ "DejaVu Sans Mono for Powerline" ];

      sansSerif = [ "DejaVu Sans" ];

    };
  };


  nix = {

    autoOptimiseStore = true;

    gc.automatic = true;

    optimise.automatic = true;

    useSandbox = true;

    allowedUsers = [ "@wheel" ];

    trustedUsers = [ "root" "@wheel" ];

    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';

  };


  nixpkgs.config.allowUnfree = true;


  programs.mtr.enable = true;


  security = {

    hideProcessInformation = true;

    protectKernelImage = true;

  };


  services.earlyoom.enable = true;


  users = {
    mutableUsers = false;

    users.root.hashedPassword = fileContents ../secrets/root;
  };

}

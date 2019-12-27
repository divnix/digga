{ config, lib, pkgs, ... }:
let
  inherit (lib)
    fileContents
    ;

in
{
  nix.package = pkgs.nixFlakes;

  nix.systemFeatures = [
    "nixos-test"
    "benchmark"
    "big-parallel"
    "kvm"
  ];

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
      dosfstools
      dnsutils
      fd
      git
      gotop
      gptfdisk
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
        np = "n profile";
        ni = "np install";
        nr = "np remove";
        ns = "n search";
        nrb = ifSudo "sudo nixos-rebuild";

        # sudo
        s = ifSudo "sudo -E ";
        si = ifSudo "sudo -i";
        se = ifSudo "sudoedit";

        # top
        top = "gotop";

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
  nixpkgs.overlays = let
    overlay = import ../pkgs;
  in
    [ overlay ];



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

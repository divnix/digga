{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.devos.defaults;
in
{
  options = {
    devos.defaults = {
      shell = mkEnableOption "sane shell aliases and prompt";
      fonts = mkEnableOption "and install useful fonts";
      packages = mkEnableOption "useful packages in the environment";
    };
  };

  config = mkMerge [
    (mkIf cfg.packages {
      environment.systemPackages = with pkgs; [
        binutils
        coreutils
        curl
        deploy-rs
        direnv
        dnsutils
        dosfstools
        fd
        git
        gotop
        gptfdisk
        iputils
        jq
        manix
        moreutils
        nix-index
        nmap
        ripgrep
        skim
        tealdeer
        utillinux
        whois
      ];
    })
    (mkIf cfg.shell {
      environment = {
        shellInit = ''
          export STARSHIP_CONFIG=${
            pkgs.writeText "starship.toml"
            (fileContents ./starship.toml)
          }
        '';


        shellAliases =
          let ifSudo = lib.mkIf config.security.sudo.enable;
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
            ns = "n search --no-update-lock-file";
            nf = "n flake";
            nepl = "n repl '<nixpkgs>'";
            srch = "ns nixos";
            orch = "ns override";
            nrb = ifSudo "sudo nixos-rebuild";
            mn = ''
              manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
            '';

            # fix nixos-option
            nixos-option = "nixos-option -I nixpkgs=${toString ../../compat}";

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
      programs.bash = {
        promptInit = ''
          eval "$(${pkgs.starship}/bin/starship init bash)"
        '';
        interactiveShellInit = ''
          eval "$(${pkgs.direnv}/bin/direnv hook bash)"
        '';
      };
    })
    (mkIf cfg.fonts {
      fonts = {
        fonts = with pkgs; [ powerline-fonts dejavu_fonts ];

        fontconfig.defaultFonts = {

          monospace = [ "DejaVu Sans Mono for Powerline" ];

          sansSerif = [ "DejaVu Sans" ];

        };
      };
    })
  ];
}

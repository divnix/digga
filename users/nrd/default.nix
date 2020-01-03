{ config, lib, pkgs, ... }:
let
  inherit (builtins)
    toFile
    readFile
    ;

  inherit (lib)
    fileContents
    mkForce
    ;


  name = "Timothy DeHerrera";
in
{

  imports = [
    ../../profiles/graphical
  ];

  users.users.root.hashedPassword = fileContents ../../secrets/root;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    nrd-logo
    pinentry_gnome
  ];

  home-manager.users.nrd = {
    home = {
      packages = mkForce [];

      file = {
        ".ec2-keys".source = ../../secrets/ec2;
        ".cargo/credentials".source = ../../secrets/cargo;
        ".zshrc".text = "#";
      };
    };

    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window.decorations = "full";
        tabspaces = 2;
        font.size = 9.0;
        cursor.style = "Beam";

        # snazzy theme
        colors = {
          # Default colors
          primary = {
            background = "0x282a36";
            foreground = "0xeff0eb";
          };

          # Normal colors
          normal = {
            black = "0x282a36";
            red = "0xff5c57";
            green = "0x5af78e";
            yellow = "0xf3f99d";
            blue = "0x57c7ff";
            magenta = "0xff6ac1";
            cyan = "0x9aedfe";
            white = "0xf1f1f0";
          };

          # Bright colors
          bright = {
            black = "0x686868";
            red = "0xff5c57";
            green = "0x5af78e";
            yellow = "0xf3f99d";
            blue = "0x57c7ff";
            magenta = "0xff6ac1";
            cyan = "0x9aedfe";
            white = "0xf1f1f0";
          };
        };
      };
    };

    programs.mpv = {
      enable = true;
      config = {
        ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
        hwdec = "auto";
        vo = "gpu";
      };
    };

    programs.git = {
      enable = true;

      aliases = {
        a = "add -p";
        co = "checkout";
        cob = "checkout -b";
        f = "fetch -p";
        c = "commit";
        p = "push";
        ba = "branch -a";
        bd = "branch -d";
        bD = "branch -D";
        d = "diff";
        dc = "diff --cached";
        ds = "diff --staged";
        r = "restore";
        rs = "restore --staged";
        st = "status -sb";

        # logging
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
        tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
        rank = "shortlog -sn --no-merges";

        # delete merged branches
        bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";
      };

      userName = name;
      userEmail = "tim.deh@pm.me";
      signing = {
        key = "8985725DB5B0C122";
        signByDefault = true;
      };
    };

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;

      matchBlocks = let
        githubKey = toFile "github"
          (readFile ../../secrets/github);

        gitlabKey = toFile "gitlab"
          (readFile ../../secrets/gitlab);
      in
        {
          github = {
            host = "github.com";
            identityFile = githubKey;
            extraOptions = {
              AddKeysToAgent = "yes";
            };
          };
          gitlab = {
            host = "gitlab.com";
            identityFile = gitlabKey;
            extraOptions = {
              AddKeysToAgent = "yes";
            };
          };
          "gitlab.company" = {
            host = "gitlab.company.com";
            identityFile = gitlabKey;
            extraOptions = {
              AddKeysToAgent = "yes";
            };
          };
        };
    };
  };

  users.groups.media.members = [ "nrd" ];

  users.users.nrd = {
    uid = 1000;
    description = name;
    isNormalUser = true;
    hashedPassword = fileContents ../../secrets/nrd;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "adbusers"
    ];
  };

  nixpkgs.overlays = let
    overlay = self: super: {
      nrd-logo = super.stdenv.mkDerivation {
        name = "nrdxp-logo";
        src = ./logo.png;
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out/share/sddm/faces
          cp $src $out/share/sddm/faces/nrd.face.icon
        '';
      };
    };
  in
    [ overlay ];
}

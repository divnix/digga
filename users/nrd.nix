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

  gpgEnableSsh = true;
in
{
  imports = [
    ../profiles/develop
  ];

  environment.shellInit = ''
    # gpg
    export GPG_TTY="$(tty)"
  '' + lib.optionalString gpgEnableSsh
    "${pkgs.gnupg}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null";

  environment.sessionVariables = {
    SSH_AUTH_SOCK = "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
  };

  home-manager.users.nrd = {
    home = {
      packages = mkForce [];

      file = {
        ".ec2-keys".source = ../secrets/ec2;
        ".cargo/credentials".source = ../secrets/cargo;
        ".zshrc".text = "#";
      };
    };

    programs.mpv = {
      enable = true;
      config = {
        ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
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
          (readFile ../secrets/github);

        gitlabKey = toFile "gitlab"
          (readFile ../secrets/gitlab);
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

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      maxCacheTtl = 1800;
      defaultCacheTtlSsh = 60480000;
      maxCacheTtlSsh = 60480000;
      enableSshSupport = gpgEnableSsh;
      extraConfig = ''
        pinentry-program ${pkgs.pinentry.tty}/bin/pinentry-tty
      '';
    };
  };

  users.users.nrd = {
    uid = 1000;
    description = name;
    isNormalUser = true;
    hashedPassword = fileContents ../secrets/nrd;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "adbusers"
    ];
  };
}

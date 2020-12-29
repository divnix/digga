{ lib, pkgs, ... }:
let
  inherit (builtins) concatStringsSep;

  inherit (lib) fileContents;

in
{
  users.defaultUserShell = pkgs.zsh;

  environment = {
    sessionVariables =
      let fd = "${pkgs.fd}/bin/fd -H";
      in
      {
        BAT_PAGER = "less";
        SKIM_ALT_C_COMMAND =
          let
            alt_c_cmd = pkgs.writeScriptBin "cdr-skim.zsh" ''
              #!${pkgs.zsh}/bin/zsh
              ${fileContents ./cdr-skim.zsh}
            '';
          in
          "${alt_c_cmd}/bin/cdr-skim.zsh";
        SKIM_DEFAULT_COMMAND = fd;
        SKIM_CTRL_T_COMMAND = fd;
      };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";

      df = "df -h";
      du = "du -h";

      ls = "exa";
      l = "ls -lhg --git";
      la = "l -a";
      t = "l -T";
      ta = "la -T";

      ps = "${pkgs.procs}/bin/procs";

      rz = "exec zsh";
    };

    systemPackages = with pkgs; [
      bat
      bzip2
      devshell
      exa
      gitAndTools.hub
      gzip
      lrzip
      p7zip
      procs
      skim
      unrar
      unzip
      xz
      zsh-completions
    ];
  };

  programs.zsh = {
    enable = true;

    enableGlobalCompInit = false;

    histSize = 10000;

    setOptions = [
      "extendedglob"
      "incappendhistory"
      "sharehistory"
      "histignoredups"
      "histfcntllock"
      "histreduceblanks"
      "histignorespace"
      "histallowclobber"
      "autocd"
      "cdablevars"
      "nomultios"
      "pushdignoredups"
      "autocontinue"
      "promptsubst"
    ];

    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';

    interactiveShellInit =
      let
        zshrc = fileContents ./zshrc;

        sources = with pkgs; [
          ./cdr.zsh
          "${skim}/share/skim/completion.zsh"
          "${oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
          "${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
          "${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
          "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
          "${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
        ];

        source = map (source: "source ${source}") sources;

        functions = pkgs.stdenv.mkDerivation {
          name = "zsh-functions";
          src = ./functions;

          ripgrep = "${pkgs.ripgrep}";
          man = "${pkgs.man}";
          exa = "${pkgs.exa}";

          installPhase =
            let basename = "\${file##*/}";
            in
            ''
              mkdir $out

              for file in $src/*; do
                substituteAll $file $out/${basename}
                chmod 755 $out/${basename}
              done
            '';
        };

        plugins = concatStringsSep "\n" ([
          "${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
        ] ++ source);

      in
      ''
        ${plugins}

        fpath+=( ${functions} )
        autoload -Uz ${functions}/*(:t)

        ${zshrc}

        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
        eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
        source ${pkgs.skim}/share/skim/key-bindings.zsh

        # needs to remain at bottom so as not to be overwritten
        bindkey jj vi-cmd-mode
      '';
  };
}

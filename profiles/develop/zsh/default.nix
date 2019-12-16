{ lib, pkgs, ... }:
let
  inherit (builtins)
    concatStringsSep
    ;


  inherit (lib)
    fileContents
    ;

in
{
  users.defaultUserShell = pkgs.zsh;

  environment = {
    sessionVariables = let
      fd = "${pkgs.fd}/bin/fd -H";
    in
      {
        BAT_PAGER = "less";
        SKIM_ALT_C_COMMAND =
          "while read line; do "
          + "line=\"'\${(Q)line}'\"; [[ -d \"'$line'\" ]] && echo \"'$line'\"; "
          + "done < $HOME/.cache/zsh-cdr/recent-dirs";
        SKIM_DEFAULT_COMMAND = fd;
        SKIM_CTRL_T_COMMAND = fd;
      };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";

      df = "df -h";
      du = "du -h";

      ls = "${pkgs.exa}/bin/exa";
      l = "ls -lh --git";
      la = "l -a";

      rz = "exec zsh";
    };

    systemPackages = with pkgs; [
      bzip2
      direnv
      gitAndTools.hub
      gzip
      lrzip
      p7zip
      skim
      unrar
      unzip
      zsh-completions
      xz
    ];
  };


  nixpkgs.overlays = let
    purs = self: super:
      { purs = super.callPackage ../../../pkgs/shells/zsh/purs {}; };
  in
    [ purs ];


  programs.zsh = {
    enable = true;

    promptInit = ''
      source ${pkgs.purs}/share/zsh/plugins/purs/purs.zsh
    '';

    interactiveShellInit = let
      zshrc = fileContents ./zshrc;

      sources = with pkgs; [
        "${skim}/share/skim/completion.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
        "${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
        "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
      ];

      source = map
        (source: "source ${source}")
        sources;

      functions = pkgs.stdenv.mkDerivation {
        name = "zsh-functions";
        src = ./functions;

        ripgrep = "${pkgs.ripgrep}";
        man = "${pkgs.man}";

        installPhase = let
          basename = "\${file##*/}";
        in
          ''
            mkdir $out

            for file in $src/*; do
              substituteAll $file $out/${basename}
              chmod 755 $out/${basename}
            done
          '';
      };

      plugins = concatStringsSep "\n"
        (
          [
            "${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
          ] ++ source
        );



    in
      ''
        ${plugins}

        fpath+=( ${functions} )
        autoload -Uz ${functions}/*(:t)

        ${zshrc}

        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
        eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
        source ${pkgs.skim}/share/skim/key-bindings.zsh
      '';
  };
}

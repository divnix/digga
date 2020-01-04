{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    cquery
    kak-lsp
    kakoune-config
    kakoune-unwrapped
    nixfmt
    python3Packages.python-language-server
    rustup
  ];

  environment.etc = {
    "xdg/kak/kakrc".source = ./kakrc;
    "xdg/kak/autoload/plugins".source = ./plugins;
    "xdg/kak/autoload/lint".source = ./lint;
    "xdg/kak/autoload/lsp".source = ./lsp;
    "xdg/kak/autoload/default".source =
      "${pkgs.kakoune-unwrapped}/share/kak/rc";
  };

  nixpkgs.overlays = let
    kak = final: prev: {
      kakoune = prev.kakoune.override {
        configure.plugins = with prev.kakounePlugins; [
          (kak-fzf.override { fzf = prev.skim; })
          kak-auto-pairs
          kak-buffers
          kak-powerline
        ];
      };

      kakoune-config = prev.writeShellScriptBin "k" ''
        XDG_CONFIG_HOME=/etc/xdg exec ${final.kakoune}/bin/kak "$@"
      '';

      kakoune-unwrapped = prev.kakoune-unwrapped.overrideAttrs (o: rec {
        version = "2019.12.10";
        src = prev.fetchFromGitHub {
          repo = "kakoune";
          owner = "mawww";
          rev = "v${version}";
          hash = "sha256-TnRQ73bIQGavXNp+wrKtYHgGem+R6JDWt333z2izYzE=";
        };
      });
    };
  in [ kak ];
}

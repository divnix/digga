final: prev: {
  # with sway/wayland support
  redshift = (prev.redshift.overrideAttrs (o: {
    src = prev.fetchFromGitHub {
      owner = "minus7";
      repo = "redshift";
      rev = "wayland";
      hash = "sha256-pyR7xNdi/83NSoC2WIrX8U+A6nU+vZBlePLXrQZnc1k=";
    };
  })).override { withAppIndicator = prev.stdenv.isLinux; };
}

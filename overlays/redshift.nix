final: prev: {
  # with sway/wayland support
  redshift = prev.redshift.overrideAttrs (o: {
    src = prev.fetchFromGitHub {
      owner = "CameronNemo";
      repo = "redshift";
      rev = "39c162ca487a59857c2eac231318f4b28855798b";
      sha256 = "1in27draskwwi097wiam26bx2szcf58297am3gkyng1ms3rz6i58";
    };
  });
}

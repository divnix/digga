final: prev: {
  # with sway/wayland support
  redshift = (prev.redshift.overrideAttrs (_:
    let
      src = prev.srcs.redshift;
    in
    {
      version = prev.lib.flk.mkVersion src;
    })).override { withAppIndicator = prev.stdenv.isLinux; };
}

let version = "1.9.0";
in
final: prev: {
  retroarchBare = prev.retroarchBare.overrideAttrs (o: {
    inherit version;

    src = prev.srcs.retroarch;

    # fix darwin builds
    nativeBuildInputs =
      if ! prev.stdenv.isLinux then
        prev.lib.filter
          (drv: ! prev.lib.hasPrefix "wayland" drv.name)
          o.nativeBuildInputs
      else
        o.nativeBuildInputs;
  });
}

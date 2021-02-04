final: prev: {
  slock = prev.slock.overrideAttrs (o: { patches = [ ../pkgs/misc/screensavers/slock/window_name.patch ]; });
}

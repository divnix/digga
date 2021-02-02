final: prev: {
  qutebrowser = prev.qutebrowser.overrideAttrs
    (self: {
      meta.platforms = prev.lib.filter (platform: ! prev.lib.elem platform [ "aarch64-linux" "i686-linux" ]) self.meta.platforms;
    });
}

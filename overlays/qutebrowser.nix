final: prev: {
  qutebrowser = prev.qutebrowser.overrideAttrs
    (self: {
      patches = self.patches ++ [ ../profiles/graphical/qutebrowser/0001-Fix-gopass-mime-format-for-qute-pass-userscript.patch ];
      meta.platforms = prev.lib.filter (platform: ! prev.lib.elem platform [ "aarch64-linux" "i686-linux" ]) self.meta.platforms;
    });
}

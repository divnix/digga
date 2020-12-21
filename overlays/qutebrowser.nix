final: prev: {
  qutebrowser = prev.qutebrowser.overrideAttrs
    (o: {
      patches = o.patches ++ [ ../profiles/graphical/qutebrowser/0001-Fix-gopass-mime-format-for-qute-pass-userscript.patch ];
    });
}

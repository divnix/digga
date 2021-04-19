# Overlays
Writing overlays is a common occurence when using a NixOS system. Therefore,
we want to keep the process as simple and straightforward as possible.

Any _.nix_ files declared in this directory will be assumed to be a valid
overlay, and will be automatically imported into all [hosts](../concepts/hosts.md), and
exported via `overlays.<file-basename>` _as well as_
`packages.<system>.<pkgName>` (for valid systems), so all you have to do is
write it.

## Example
overlays/kakoune.nix:
```nix
final: prev: {
  kakoune = prev.kakoune.override {
    configure.plugins = with final.kakounePlugins; [
      (kak-fzf.override { fzf = final.skim; })
      kak-auto-pairs
      kak-buffers
      kak-powerline
      kak-vertical-selection
    ];
  };
}
```

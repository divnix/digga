final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  vscode-utils = prev.vscode-utils // (prev.callPackage ./misc/vscode-extensions/vscode-utils.nix { });

  vscode-extensions = prev.vscode-extensions // (final.callPackage ./misc/vscode-extensions { });
}

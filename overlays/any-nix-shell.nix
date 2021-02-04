final: prev: {
  any-nix-shell = prev.any-nix-shell.overrideAttrs
    (o: {
      src = prev.fetchFromGitHub {
        owner = "haslersn";
        repo = "any-nix-shell";
        rev = "e6b86e6e6d86cf7bcbc2691596d54d0a1db29d29";
        hash = "sha256-ZmMl58sYVj5TVw19nxPht5nAv9qWnIyImRhs1/TrsRc=";
      };
    });
}

final: prev: {
  nix-zsh-completions = prev.nix-zsh-completions.overrideAttrs (o: {
    src = prev.fetchFromGitHub {
      owner = "Ma27";
      repo = "nix-zsh-completions";
      hash = "sha256-3HVYez/wt7EP8+TlhTppm968Wl8x5dXuGU0P+8xNDpo=";
      rev = "939c48c182e9d018eaea902b1ee9d00a415dba86";
    };
  });
}

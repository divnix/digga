final: prev: {
  nix-zsh-completions = prev.nix-zsh-completions.overrideAttrs (o: {
    src = prev.fetchFromGitHub {
      owner = "Ma27";
      repo = "nix-zsh-completions";
      hash = "sha256-Iz04FVW7UJ2SOs3XlSF1g9HhMOvsjFbYh5baHBeCtZM=";
      rev = "5a0f218ea4a452d63f90efe71e0c6ba722ec7311";
    };
  });
}

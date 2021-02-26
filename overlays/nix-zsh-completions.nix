final: prev: {
  nix-zsh-completions = prev.nix-zsh-completions.overrideAttrs (_:
    let
      src = prev.srcs.nix-zsh-completions;
    in
    {
      inherit src;
      version = prev.lib.flk.mkVersion src;
    });
}

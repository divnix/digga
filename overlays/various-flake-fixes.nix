final: prev: {
  # Since: https://github.com/NixOS/nixpkgs/pull/126137
  nix-direnv =
    if builtins.hasAttr "enableFlakes" prev.nix-direnv.override.__functionArgs
    then
      prev.nix-direnv.override
        {
          enableFlakes = true;
        }
    else prev.nix-direnv;
}

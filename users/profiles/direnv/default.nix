{
  programs.direnv = {
    enable = true;
    stdlib = ''
      use_flake() {
        mkdir -p $(direnv_layout_dir)
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
      }
    '';
  };
}

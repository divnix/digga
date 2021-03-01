{
  description = "Package sources";

  inputs = {
    # git ls-remote https://github.com/libretro/retroarch
    retroarch.url = "github:libretro/retroarch/v1.9.0";
    retroarch.flake = false;
    # git ls-remote https://github.com/haslersn/any-nix-shell
    any-nix-shell.url = "github:haslersn/any-nix-shell";
    any-nix-shell.flake = false;
    # git ls-remote https://github.com/Ma27/nix-zsh-completions
    nix-zsh-completions.url = "github:Ma27/nix-zsh-completions";
    nix-zsh-completions.flake = false;
    redshift.url = "github:minus7/redshift/wayland";
    redshift.flake = false;
    # git ls-remote https://github.com/MarianArlt/sddm-chili
    sddm-chili.url = "github:MarianArlt/sddm-chili/0.1.5";
    sddm-chili.flake = false;
    steamcompmgr.url = "github:gamer-os/steamos-compositor-plus";
    steamcompmgr.flake = false;
    # git ls-remote https://github.com/benhoyt/inih
    libinih.url = "github:benhoyt/inih/r53";
    libinih.flake = false;
    wii-u-gc-adapter.url = "github:ToadKing/wii-u-gc-adapter";
    wii-u-gc-adapter.flake = false;
    pure.url = "github:sindresorhus/pure";
    pure.flake = false;
  };

  outputs = { ... }: { };
}

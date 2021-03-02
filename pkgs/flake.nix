{
  description = "Package sources";

  inputs = {
    retroarch.url = "github:libretro/retroarch/v1.9.0";
    retroarch.flake = false;
    any-nix-shell.url = "github:haslersn/any-nix-shell";
    any-nix-shell.flake = false;
    nix-zsh-completions.url = "github:Ma27/nix-zsh-completions/flakes";
    nix-zsh-completions.flake = false;
    redshift.url = "github:minus7/redshift/wayland";
    redshift.flake = false;
    sddm-chili.url = "github:MarianArlt/sddm-chili/0.1.5";
    sddm-chili.flake = false;
    steamcompmgr.url = "github:gamer-os/steamos-compositor-plus";
    steamcompmgr.flake = false;
    libinih.url = "github:benhoyt/inih/r53";
    libinih.flake = false;
    wii-u-gc-adapter.url = "github:ToadKing/wii-u-gc-adapter";
    wii-u-gc-adapter.flake = false;
    pure.url = "github:sindresorhus/pure";
    pure.flake = false;
  };

  outputs = { ... }: { };
}

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    farbfeld
    xss-lock
    imgurbash2
    dzvol
    maim
    xclip
    xorg.xdpyinfo
  ];

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = import ./xmonad.hs.nix { inherit pkgs; };
  };

  services.picom = {
    enable = true;
    inactiveOpacity = "0.8";
    settings = {
      "unredir-if-possible" = true;
      "focus-exclude" = "id = 0x2400001";
    };
  };

  programs.slock.enable = true;
}

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    farbfeld
    xss-lock
    imgurbash2
    dzvol
    maim
    xclip
  ];

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = import ./xmonad.hs.nix { inherit pkgs; };
  };

  programs.slock.enable = true;
}

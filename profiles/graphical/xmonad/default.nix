{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ xss-lock dzvol maim ];

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = import ./xmonad.hs.nix { inherit pkgs; };
  };

  programs.slock.enable = true;
}

{ pkgs, ... }: {
  imports = [ ./udev.nix ];
  environment.systemPackages = with pkgs; [
    retroarchBare
    steam-run
    pcsx2
    qjoypad
  ];

  services.wii-u-gc-adapter.enable = true;

  # fps games on laptop need this
  services.xserver.libinput.disableWhileTyping = false;

  # Launch steam from display managers
  services.xserver.windowManager.steam = { enable = true; };

  # 32-bit support needed for steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  hardware.steam-hardware.enable = true;

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  # improve wine performance
  environment.sessionVariables = { WINEDEBUG = "-all"; };
}

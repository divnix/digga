{ unstablePkgs, ... }: {
  environment.systemPackages = with unstablePkgs; [
    discord
    riot-desktop
    signal-desktop
  ];
}


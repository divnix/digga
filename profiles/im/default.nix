{ unstablePkgs, ... }: {
  environment.systemPackages = with unstablePkgs; [
    discord
    element-desktop
    signal-desktop
  ];
}


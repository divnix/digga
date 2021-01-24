{
  imports =
    let
      profiles = builtins.filter (n: n != ../profiles/core)
        (import ../profiles/list.nix);
    in
    profiles ++ [ ../users/nixos ../users/root ];

  security.mitigations.acceptRisk = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}

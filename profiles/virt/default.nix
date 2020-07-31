{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemuRunAsRoot = false;
  };

  # you'll need to add your user to 'libvirtd' group to use virt-manager
  environment.systemPackages = with pkgs; [ virt-manager ];

  nixpkgs.overlays =
    let
      overlay = final: prev: {

        # Patch libvirt to use ebtables-legacy
        libvirt =
          if prev.libvirt.version <= "5.4.0" && prev.ebtables.version
            > "2.0.10-4" then
            prev.libvirt.overrideAttrs (o: { EBTABLES_PATH = "${final.ebtables}/bin/ebtables-legacy"; })
          else
            prev.libvirt;
      };
    in
    [ overlay ];
}

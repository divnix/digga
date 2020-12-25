{ pkgs, ... }: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemuRunAsRoot = false;
      allowedBridges = [
        "virbr0"
        "virbr1"
      ];
    };

    podman.enable = true;
    oci-containers.backend = "podman";
  };

  # you'll need to add your user to 'libvirtd' group to use virt-manager
  environment.systemPackages = with pkgs; [ virt-manager vagrant ];

  environment.shellAliases.docker = "podman";

  environment.sessionVariables = {
    VAGRANT_DEFAULT_PROVIDER = "libvirt";
  };
}

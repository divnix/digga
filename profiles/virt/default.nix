{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemuRunAsRoot = false;
  };

  # you'll need to add your user to 'libvirtd' group to use virt-manager
  environment.systemPackages = with pkgs; [ virt-manager vagrant ];


  environment.sessionVariables = {
    VAGRANT_DEFAULT_PROVIDER = "libvirt";
  };
}

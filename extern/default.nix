{ inputs }: with inputs;
{
  modules = [
    home.nixosModules.home-manager
    ci-agent.nixosModules.agent-profile
  ];

  overlays = [
    nur.overlay
    devshell.overlay
  ];

  # passed to all nixos modules
  specialArgs = {
    unstableModulesPath = "${master}/nixos/modules";
    hardware = nixos-hardware.nixosModules;
  };
}

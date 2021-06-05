{ modulesPath, suites, ... }: {
  ### root password is empty by default ###
  imports = [ "${modulesPath}/virtualisation/digital-ocean-config.nix" ] ++ suites.base;

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    openFirewall = true;
    passwordAuthentication = true;
  };
}

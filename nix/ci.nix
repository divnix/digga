let
  inherit (default.inputs.nixos.lib) recurseIntoAttrs;

  default = (import "${../.}/compat").defaultNix;
  packages = import ../default.nix;
in
{
  # platforms supported by our hercules-ci agent
  inherit (packages)
    aarch64-linux
    i686-linux
    x86_64-linux
    ;

  devShell = recurseIntoAttrs {
    inherit (default.devShell)
      aarch64-linux
      i686-linux
      x86_64-linux
      ;
  };

  nixos = default.nixosConfigurations.NixOS.config.system.build.ci;
}

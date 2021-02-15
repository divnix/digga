let
  inherit (default.inputs.nixos.lib) mapAttrs recurseIntoAttrs;

  default = (import "${../.}/compat").defaultNix;
  packages = import ../default.nix;
in
{
  checks = recurseIntoAttrs (mapAttrs (_: v: recurseIntoAttrs v) {
    inherit (default.checks)
      aarch64-linux
      i686-linux
      x86_64-linux
      ;
  });

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

let
  inherit (default.inputs.nixos.lib) recurseIntoAttrs;

  default = (import "${../.}/compat").defaultNix;

  packages = import ../default.nix;

  shell = recurseIntoAttrs {
    inherit (default.devShell)
      i686-linux x86_64-linux aarch64-linux;
  };

  ci = recurseIntoAttrs {
    nixos = default.nixosConfigurations.NixOS.config.system.build.ci;
  };
in
{
  inherit shell ci;
  # platforms supported by our hercules-ci agent
  inherit (packages)
    i686-linux
    x86_64-linux
    aarch64-linux
    ;
}

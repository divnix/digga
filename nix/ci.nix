let
  inherit (default.inputs.nixos.lib) recurseIntoAttrs;

  default = (import ../compat).defaultNix;

  packages = import ../default.nix;

  shell = recurseIntoAttrs default.devShell.x86_64-linux;

  # failing on hercules-ci, probably until nix is updated
  # ci = recurseIntoAttrs
  #   default.nixosConfigurations.ci.config.system.build.toplevel;
in
{
  inherit shell;
  # platforms supported by our hercules-ci agent
  inherit (packages)
    i686-linux
    x86_64-linux
    aarch64-linux
    ;
}

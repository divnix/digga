let
  inherit (import
    (
      let lock = builtins.fromJSON (builtins.readFile ./flake.lock); in
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
    )
    { src = ./.; }
  ) defaultNix;
in
  # Pass this flake as inputs.digga
  defaultNix // {
    inputs = defaultNix.inputs // { digga = defaultNix; };
    shell = import ./shell.nix;
  }


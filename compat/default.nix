let
  inherit (lock.nodes.flake-compat.locked) rev narHash;

  lock = builtins.fromJSON (builtins.readFile ../flake.lock);
  flake = (import
    (
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${rev}.tar.gz";
        sha256 = narHash;
      }
    )
    {
      src = ../.;
    });
in
flake

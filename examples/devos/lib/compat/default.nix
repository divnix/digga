let
  lock = builtins.fromJSON (builtins.readFile builtins.path {
    path = ../../flake.lock;
    name = "lockPath";
  });
  flake =
    import
    (
      fetchTarball {
        url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
    )
    {
      src = builtins.path {
        path = ../../.;
        name = "projectRoot";
      };
    };
in
  flake

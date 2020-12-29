let
  inherit (builtins)
    fetchTarball
    fromJSON
    readFile
    ;
  lockfile = fromJSON (readFile ../flake.lock);
in
input:
let
  locked = lockfile.nodes."${input}".locked;
  inherit (locked) rev narHash owner repo;
in
fetchTarball {
  url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
  sha256 = narHash;
}

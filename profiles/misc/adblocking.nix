{ pkgs, ... }:
let
  inherit (builtins) concatStringsSep;
  inherit (pkgs) fetchFromGitHub stdenv gnugrep;
  inherit (builtins) readFile fetchurl;

  hosts = stdenv.mkDerivation {
    name = "hosts";

    src = fetchFromGitHub {
      owner = "StevenBlack";
      repo = "hosts";
      rev = "d072586d5e34ee11beef17a58fcca2ad4e319953";
      sha256 = "0yq71w7ycm35fyjxhax22cmyn3b6lakw0n1d8rkwzkraa7f6w4pp";
    };

    nativeBuildInputs = [ gnugrep ];

    installPhase = ''
      mkdir -p $out/etc

      # filter whitelist
      grep -Ev '(${whitelist})' hosts > $out/etc/hosts

      # filter blacklist
      cat << EOF >> $out/etc/hosts
      ${blacklist}
      EOF
    '';
  };

  whitelist = concatStringsSep "|" [
    ".*pirate(bay|proxy).*"
  ];

  blacklist = concatStringsSep "\n0.0.0.0 " [
    "# auto-generated: must be first"

    # starts here
  ];

in
{
  networking.extraHosts = readFile "${hosts}/etc/hosts";
}

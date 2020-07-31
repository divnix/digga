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
      rev = "ca3a99a0499add858969ce8747049e681b85a2e2";
      hash = "sha256-DMIal28cTr/8oij89LwSvNp7n1QiwzNmwsiSzV9X49c=";
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

  whitelist = concatStringsSep "|" [ ".*pirate(bay|proxy).*" ];

  blacklist = concatStringsSep ''

    0.0.0.0 ''
    [
      "# auto-generated: must be first"

      # starts here
    ];

in
{ networking.extraHosts = readFile "${hosts}/etc/hosts"; }

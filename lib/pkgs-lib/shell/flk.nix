{ stdenv }:
let
  name = "flk";
in
stdenv.mkDerivation {
  inherit name;

  src = ./flk.sh;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install $src $out/bin/${name}
  '';

  checkPhase = ''
    ${stdenv.shell} -n -O extglob $out/bin/${name}
  '';

  meta.description = "Build, deploy, and install NixOS";
}

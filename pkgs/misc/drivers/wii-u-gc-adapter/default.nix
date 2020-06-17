{ stdenv, fetchFromGitHub, pkgconfig, libudev, libusb, ... }:

stdenv.mkDerivation {
  name = "wii-u-gc-adapter";

  buildInputs = [ pkgconfig libudev libusb ];

  src = fetchFromGitHub {
    owner = "ToadKing";
    repo = "wii-u-gc-adapter";
    rev = "ae6b46d7a2b32068e746f1d2d816f4b3d6a7ac80";
    hash = "sha256-Dk4jMaL5P85yxH3pDVBDNKjtGL4gRkhN5CJqZnOAshE=";
  };

  installPhase = ''
    mkdir -p $out/bin
    install wii-u-gc-adapter $out/bin
  '';

  hardeningDisable = [ "format" ];
}

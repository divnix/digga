{ stdenv, fetchFromGitHub, pkgconfig, libudev, libusb, ... }:

stdenv.mkDerivation {
  pname = "wii-u-gc-adapter";
  version = "ae6b46d";

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

  meta = with stdenv.lib; {
    description = "Tool for using the Wii U GameCube Adapter on Linux";
    homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.mit;
    inherit version;
  };
}

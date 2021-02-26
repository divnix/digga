{ lib, stdenv, pkgconfig, libudev, libusb, srcs, ... }:

stdenv.mkDerivation {
  pname = "wii-u-gc-adapter";
  version = lib.flk.mkVersion srcs.wii-u-gc-adapter;

  buildInputs = [ pkgconfig libudev libusb ];

  src = srcs.wii-u-gc-adapter;

  installPhase = ''
    mkdir -p $out/bin
    install wii-u-gc-adapter $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Tool for using the Wii U GameCube Adapter on Linux";
    homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.mit;
    platforms = platforms.linux;
    inherit version;
  };
}

{ stdenv, pkgconfig, alsaLib, x11, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "dzvol";
  src = fetchFromGitHub {
    owner = "allevaton";
    repo = "dzvol";
    rev = "ca7099520525df2d54ad24f6def22819d5f36b3b";
    sha256 = "1xx7xai6hzrm3gs026z41pl877y849vpfi71syj6cj3ir9h16lpz";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp dzvol $out/bin
  '';

  buildInputs = [ pkgconfig alsaLib x11 ];
  hardeningDisable = [ "format" ];
}

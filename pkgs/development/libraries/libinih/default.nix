{ stdenv, meson, ninja, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  name = "libinih";
  version = "r50";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "inih";
    rev = "${version}";
    hash = "sha256-GF+TVEysaXJxSBBjMsTr2IQvRKlzdEu3rlPQ88PE3nI=";
  };

  buildInputs = [ meson ninja ];

  mesonFlags = ''
    -Ddefault_library=shared
    -Ddistro_install=true
  '';
}

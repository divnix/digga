{ stdenv, meson, ninja, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "libinih";
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

  meta = with stdenv.lib; {
    description = "Simple .INI file parser in C";
    homepage = "https://github.com/benhoyt/inih";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.bsd3;
    inherit version;
  };
}

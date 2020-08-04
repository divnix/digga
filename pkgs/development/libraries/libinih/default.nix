{ stdenv, meson, ninja, fetchFromGitHub, ... }:
let version = "r50";
in
stdenv.mkDerivation {
  pname = "libinih";
  inherit version;

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
    platforms = platforms.all;
    inherit version;
  };
}

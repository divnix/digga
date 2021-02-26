{ stdenv, lib, meson, ninja, srcs, ... }:
let version = "r53";
in
stdenv.mkDerivation {
  pname = "libinih";
  inherit version;

  src = srcs.libinih;

  buildInputs = [ meson ninja ];

  mesonFlags = ''
    -Ddefault_library=shared
    -Ddistro_install=true
  '';

  meta = with lib; {
    description = "Simple .INI file parser in C";
    homepage = "https://github.com/benhoyt/inih";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.bsd3;
    platforms = platforms.all;
    inherit version;
  };
}

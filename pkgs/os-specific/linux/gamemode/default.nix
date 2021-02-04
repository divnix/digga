let version = "1.5.1";
in
{ stdenv
, meson
, ninja
, polkit
, pkgconfig
, systemd
, dbus
, libinih
, fetchFromGitHub
, ...
}:

stdenv.mkDerivation {
  pname = "gamemode";
  inherit version;

  src = fetchFromGitHub {
    owner = "FeralInteractive";
    repo = "gamemode";
    rev = "${version}";
    hash = "sha256-x3VM7HJL4+zLDBdCm0ekc0UX33lrRWlOieJjihhA5L4=";
  };

  prePatch = ''
    substituteInPlace daemon/gamemode-tests.c --replace "/usr/bin/gamemoderun" $out/bin/gamemoderun
    substituteInPlace daemon/gamemode-gpu.c --replace "/usr/bin/pkexec" ${polkit}/bin/pkexec
    substituteInPlace daemon/gamemode-context.c --replace "/usr/bin/pkexec" ${polkit}/bin/pkexec
    substituteInPlace lib/gamemode_client.h --replace 'dlopen("' 'dlopen("${
      placeholder "out"
    }/lib/'
  '';

  buildInputs = [ meson ninja pkgconfig systemd dbus libinih ];

  mesonFlags = ''
    -Dwith-util=false
    -Dwith-examples=false
    -Dwith-systemd-user-unit-dir=${placeholder "out"}/lib/systemd/user
  '';

  meta = with stdenv.lib; {
    description = "Optimise Linux system performance on demand";
    homepage = "https://github.com/FeralInteractive/gamemode";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.bsd3;
    platforms = platforms.linux;
    broken = true;
    inherit version;
  };
}

{ stdenv, appstream, meson, ninja, pkgsi686Linux, polkit, pkgconfig, systemd
, dbus, libinih, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "gamemode";
  version = "1.5.1";

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

}

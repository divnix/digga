{ stdenv
, fetchFromGitHub
, libudev
, SDL
, SDL_image
, libXdamage
, libXcomposite
, libXrender
, libXext
, libXxf86vm
, pkgconfig
, autoreconfHook
, gnumake
}:

stdenv.mkDerivation {
  name = "steamcompmgr";
  src = fetchFromGitHub {
    owner = "gamer-os";
    repo = "steamos-compositor-plus";
    rev = "c3855fcb5015ecdca299ee4b46b9f90c7a6788de";
    hash = "sha256-sRthjN+pnabl67PuJS+zbUznW4ws0fub0R9bTzelg18=";
  };

  buildInputs = [
    libudev
    SDL
    SDL_image
    libXdamage
    libXcomposite
    libXrender
    libXext
    libXxf86vm
    pkgconfig
    autoreconfHook
    gnumake
  ];

  meta = with stdenv.lib; {
    description = "SteamOS Compositor";
    homepage = "https://github.com/steamos-compositor-plus";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.bsd2;
    inherit version;
  };
}

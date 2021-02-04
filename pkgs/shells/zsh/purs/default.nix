{ stdenv, fetchFromGitHub, openssl, pkgconfig, rustPlatform }:

with rustPlatform;
let
  inherit (builtins) readFile toFile;

  init = toFile "init.sh" "${readFile ./init.sh}";
in
buildRustPackage {
  pname = "purs";
  version = "0.1.0";

  srcs = fetchFromGitHub {
    owner = "TimB87";
    repo = "purs";
    rev = "ee40ff5edf79a1aee7f87b97ca32744944778769";
    hash = "sha256-ETU7dDGVa2ggM+qoFgi8k4MJNuqb3kNCX9ZbEA4r5PM=";
  };

  nativeBuildInputs = [ openssl pkgconfig ];

  cargoSha256 = "sha256-FPxJuVyuuHdo2dNLhmJK6xXy12LJsbKNWBAo8pcuLDg=";

  preBuild = ''
    export PKG_CONFIG_PATH=${openssl.dev}/lib/pkgconfig
    export OPENSSL_DIRS=${openssl.out}:${openssl.dev}
  '';

  postInstall = ''
    mkdir -p $out/share/zsh/plugins/purs

    substitute ${init} $out/share/zsh/plugins/purs/purs.zsh \
      --subst-var-by PURS $out
  '';

  meta = with stdenv.lib; {
    description = "A Pure-inspired prompt in Rust";
    homepage = "https://github.com/xcambar/purs";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.mit;
    platforms = platforms.unix;
    inherit version;
  };
}

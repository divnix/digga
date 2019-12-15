{ stdenv, fetchFromGitHub, openssl, pkgconfig, rustPlatform }:

with rustPlatform;
let
  inherit (builtins)
    readFile
    toFile
    ;


  init = toFile "init.sh" "${readFile ./init.sh}";
in
buildRustPackage rec {
  pname = "purs";
  version = "0.1.0";

  srcs = fetchFromGitHub {
    owner = "xcambar";
    repo = "purs";
    rev = "09ed252625b691841b0043699fd4ab590edabe29";
    hash = "sha256-QwkbqNROksRo+QmRrgkWuoPzPb2XBwavEtlR9oqAXDQ=";
  };

  buildInputs = [
    openssl
    pkgconfig
  ];

  cargoSha256 = "sha256-vyO2JRRA7FCNVmIeN1xybQXkdgoHbhMGT2AhUJEnp0s=";

  postInstall = ''
    mkdir -p $out/share/zsh/plugins/purs

    substitute ${init} $out/share/zsh/plugins/purs/purs.zsh \
      --subst-var-by PURS $out
  '';

  meta = with stdenv.lib; {
    description = "A Pure-inspired prompt in Rust";
    homepage = https://github.com/xcambar/purs;
    maintainers = [ maintainers.nrdxp ];
    license = licenses.mit;
    inherit version;
  };
}

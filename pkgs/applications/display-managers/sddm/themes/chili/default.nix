{ stdenv, fetchFromGitHub, ... }:
stdenv.mkDerivation rec {
  name = "sddm-chili";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "kde-plasma-chili";
    rev = "${version}";
    hash = "sha256-fWRf96CPRQ2FRkSDtD+N/baZv+HZPO48CfU5Subt854=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/chili

    cp -r * $out/share/sddm/themes/chili
  '';
}

{ stdenv, fetchFromGitHub, ... }:
let version = "0.1.5";
in
stdenv.mkDerivation {
  pname = "sddm-chili";
  inherit version;

  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "${version}";
    hash = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/chili

    cp -r * $out/share/sddm/themes/chili
  '';

  meta = with stdenv.lib; {
    description = "The hottest theme around for SDDM";
    homepage = "https://github.com/MarianArlt/sddm-chili";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.gpl3;
    inherit version;
  };
}

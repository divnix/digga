{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "dejavu-nerdfont-${version}";
  version = "2.0.0";

  src = fetchzip {
    url =
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/DejaVuSansMono.zip";
    hash = "sha256-yMvKzt5CKpK1bThT25lqSyRvZRCFvo6HHbTj+ripdCo=";
    stripRoot = false;
  };
  buildCommand = ''
    install --target $out/share/fonts/opentype -D $src/*Mono.ttf
  '';

  meta = with stdenv.lib; {
    description = "Nerdfont version of DejaVu";
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    license = licenses.mit;
    maintainers = [ maintainers.nrdxp ];
    inherit version;
  };
}

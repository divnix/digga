{ lib, stdenv, srcs }:
let version = lib.flk.mkVersion srcs.pure;
in
stdenv.mkDerivation {
  pname = "pure";
  inherit version;

  srcs = srcs.pure;

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/share/zsh/plugins/pure
    cp -r ./ $out/share/zsh/plugins/pure
  '';

  meta = with lib; {
    description = "Pretty, minimal and fast ZSH prompt";
    homepage = "https://github.com/sindresorhus/pure";
    maintainers = [ maintainers.nrdxp ];
    platforms = platforms.unix;
    license = licenses.mit;
    inherit version;
  };
}

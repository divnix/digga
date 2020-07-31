{ stdenv, fetchFromGitHub }:
let version = "0e87bd8";
in
stdenv.mkDerivation {
  pname = "pure";
  inherit version;

  srcs = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "0e87bd897bb67049329c55174dcc643926337b01";
    hash = "sha256-JytsTviVHphYnP5KTbSkbaiNeg2fMufYc6r0X0SQyqI=";
  };

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/share/zsh/plugins/pure
    cp -r ./ $out/share/zsh/plugins/pure
  '';

  meta = with stdenv.lib; {
    description = "Pretty, minimal and fast ZSH prompt";
    homepage = "https://github.com/sindresorhus/pure";
    maintainers = [ maintainers.nrdxp ];
    license = licenses.mit;
    inherit version;
  };
}

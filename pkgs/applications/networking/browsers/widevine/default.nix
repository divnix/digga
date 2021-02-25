{ stdenv, patchelf, gcc, glib, nspr, nss, unzip, ... }:
let
  inherit (builtins) fetchurl;
  inherit (stdenv) lib mkDerivation;
  mkrpath = p: "${lib.makeSearchPathOutput "lib" "lib64" p}:${lib.makeLibraryPath p}";
in
mkDerivation rec {
  name = "${pname}-${version}";
  pname = "widevine-cdm";
  version = "4.10.1582.2";

  src = fetchurl {
    url = "https://dl.google.com/${pname}/${version}-linux-x64.zip";
    sha256 = "sha256:0g9z8fnzy970klnms92z16saagvxla06bczqrcrjcf0b0d68dzl7";
  };

  unpackCmd = "unzip -d ./src $curSrc";

  nativeBuildInputs = [ unzip ];

  PATCH_RPATH = mkrpath [ gcc.cc glib nspr nss ];

  patchPhase = ''
    patchelf --set-rpath "$PATCH_RPATH" libwidevinecdm.so
  '';

  installPhase = ''
    install -vD libwidevinecdm.so \
      "$out/lib/libwidevinecdm.so"
  '';

  meta.platforms = [ "x86_64-linux" ];
}

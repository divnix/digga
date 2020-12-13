{ stdenv
, fetchFromGitHub
, fetchurl
, makeWrapper
, dotnetPackages
, dotnetCorePackages
, openssl
, boost
, libsodium
, pkgconfig
, icu
, zeromq
}:
let
  deps = import ./deps.nix { inherit fetchurl; };

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  Nuget = dotnetPackages.Nuget;

  nugetSource = stdenv.mkDerivation {
    pname = "${pname}-nuget-deps";
    inherit version;

    dontUnpack = true;
    dontInstall = true;

    nativeBuildInputs = [ Nuget ];

    buildPhase = ''
      export HOME=$(mktemp -d)
      mkdir -p $out/lib

      nuget sources Disable -Name "nuget.org"
      for package in ${toString deps}; do
        nuget add $package -Source $out/lib
      done
    '';
  };

  pname = "miningcore";
  version = "50";

  projectName = "Miningcore";
  projectConfiguration = "Release";
  projectRuntime = "linux-x64";
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "akshaynexus";
    repo = "miningcore";
    rev = "318c0c26a8f0fd7fd7588fb6845abacf6fc27c79";
    hash = "sha256-TZrhNE/5XUxAirAXRnAZax4OBOeWQlwNkiackXuJ7bI=";
  };

  buildInputs = [
    boost
    libsodium
    openssl
    Nuget
    dotnet-sdk
    makeWrapper
    pkgconfig
    zeromq
  ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
    export DOTNET_ROOT="${dotnet-sdk}/bin"

    nuget sources Disable -Name "nuget.org"

    dotnet restore \
      --source ${nugetSource}/lib \
      --runtime ${projectRuntime} \
      src/${projectName}

    dotnet publish \
      --no-restore \
      --runtime ${projectRuntime} \
      --configuration ${projectConfiguration} \
      src/${projectName}
  '';

  installPhase = ''
    mkdir -p $out
    cp -r src/${projectName}/bin/${projectConfiguration}/netcoreapp3.1/${projectRuntime}/publish $out/lib
    mkdir -p $out/bin
    makeWrapper $out/lib/Miningcore $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
      openssl
      icu
      zeromq
    ]} \
      --run "cd $out/lib"
  '';

  # If we don't disable stripping the executable fails to start with segfault
  dontStrip = true;

  meta = with stdenv.lib; {
    description = "A high-performance Mining-Pool Engine";
    homepage = "https://github.com/akshaynexus/miningcore";
    license = licenses.mit;
    maintainers = with maintainers; [ nrdxp ];
    platforms = [ "x86_64-linux" ];
  };
}

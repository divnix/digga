let version = "1.6.0";
in
final: prev: {
  pcsx2 = prev.pcsx2.overrideAttrs (o: {
    inherit version;
    src = prev.fetchFromGitHub {
      owner = "PCSX2";
      repo = "pcsx2";
      rev = "v${version}";
      hash = "sha256-iqNOLhNqj+ja0YIyVi/6gZXBYGN+eu02LUiUIwacSBQ=";
    };
  });
}

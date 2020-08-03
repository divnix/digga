let version = "1.8.9";
in
final: prev: {
  retroarchBare = prev.retroarchBare.overrideAttrs (o: {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "libretro";
      repo = "RetroArch";
      hash = "sha256-1kiq2ZobaPIhsWviOPCmDM3oJ0wJLmvYZ9PaqywF8I0=";
      rev = "v${version}";
    };
  });
}

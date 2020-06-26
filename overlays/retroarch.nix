final: prev: {
  retroarchBare = prev.retroarchBare.overrideAttrs (o: rec {
    version = "1.8.9";

    src = prev.fetchFromGitHub {
      owner = "libretro";
      repo = "RetroArch";
      hash = "sha256-1kiq2ZobaPIhsWviOPCmDM3oJ0wJLmvYZ9PaqywF8I0=";
      rev = "v${version}";
    };
  });
}

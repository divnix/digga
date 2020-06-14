final: prev: {
  retroarchBare = prev.retroarchBare.overrideAttrs (o: rec {
    version = "1.8.8";

    src = prev.fetchFromGitHub {
      owner = "libretro";
      repo = "RetroArch";
      hash = "sha256-rPMaTs98dmP0nkuHJRt5DmCgzk9imfJ+rgW9zfEqUFA=";
      rev = "v${version}";
    };
  });
}

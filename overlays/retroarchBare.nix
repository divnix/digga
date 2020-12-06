let version = "1.9.0";
in
final: prev: {
  retroarchBare = prev.retroarchBare.overrideAttrs (o: {
    inherit version;

    src = prev.fetchFromGitHub {
      owner = "libretro";
      repo = "RetroArch";
      hash = "sha256-dzPOuT+v1JtYzvAtqZ/eVWQSYQLAWX3TyS3jXdBmDdg=";
      rev = "v${version}";
    };
  });
}

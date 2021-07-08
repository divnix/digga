if [[ "$1" == "core" || "$1" == "community" ]]; then
  nix flake new -t "github:divnix/devos/$1" "${2:-devos}"
else
  echo "bud get (core|community) [DEST]"
  exit 1
fi

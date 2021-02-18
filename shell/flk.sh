[[ -d "$DEVSHELL_ROOT" ]] ||
  {
    echo "This script must be run from devos's devshell" >&2
    exit 1
  }

shopt -s extglob

HOSTNAME="$(hostname)"

usage () {
  printf "%b\n" \
    "\e[4mUsage\e[0m: $(basename $0) COMMAND [ARGS]\n" \
    "\e[4mCommands\e[0m:"

  printf "  %-30s %s\n\n" \
  "up" "Generate $DEVSHELL_ROOT/hosts/up-$HOSTNAME.nix" \
  "update" "Update and commit the lock file" \
  "get [core|community] DEST" "Copy the desired template to DEST" \
  "iso HOST" "Generate an ISO image of HOST" \
  "install HOST [ARGS]" "Shortcut for nixos-install" \
  "home HOST USER [switch]" "Home-manager config of USER from HOST" \
  "HOST [switch|boot|test]" "Shortcut for nixos-rebuild"
}

case "$1" in
  ""|"-h"|"help"|*(-)"help")
    usage
    ;;

  "up")
    mkdir -p "$DEVSHELL_ROOT/up"

    nixos-generate-config --dir "$DEVSHELL_ROOT/up/$HOSTNAME"

    printf "%s\n" \
      "{ suites, ... }:" \
      "{" \
      "  imports = [" \
      "    ../up/$HOSTNAME/configuration.nix" \
      "  ] ++ suites.core;" \
      "}" > "$DEVSHELL_ROOT/hosts/up-$HOSTNAME.nix"

    git add -f \
      "$DEVSHELL_ROOT/up/$HOSTNAME" \
      "$DEVSHELL_ROOT/hosts/up-$HOSTNAME.nix"
    ;;

  "update")
    nix flake update --recreate-lock-file --commit-lock-file "$DEVSHELL_ROOT"
    ;;

  "get")
    if [[ "$2" == "core" || "$2" == "community" ]]; then
      nix flake new -t "github:divnix/devos/$2" "${3:-flk}"
    else
      echo "flk get [core|community] {dest}"
      exit 1
    fi
    ;;

  "iso")
    nix build \
      "$DEVSHELL_ROOT#nixosConfigurations.$2.config.system.build.iso" \
      "${@:3}"
    ;;

  "install")
    sudo nixos-install --flake "$DEVSHELL_ROOT#$2" "${@:3}"
    ;;

  "home")
    ref="$DEVSHELL_ROOT/#hmActivationPackages.$2.$3"

    if [[ "$4" == "switch" ]]; then
      nix build "$ref" && result/activate &&
        unlink result

    else
      nix build "$ref" "${@:4}"
    fi
    ;;

  *)
    sudo nixos-rebuild --flake "$DEVSHELL_ROOT#$1" "${@:2}"
    ;;
esac

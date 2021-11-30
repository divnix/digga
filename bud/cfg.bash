#!/usr/bin/env bash

set -e -o pipefail

function echo () {
  printf "$1\n"
}

# Turns an attr path specified like "nixos.profiles.profile" into
# it's proper devos structured filesystem path
function parse_attrpath () {
  attr_origpath="$1"

  if [[ $attr_origpath == "nixos."* ]]; then
    attr_path="${attr_origpath/nixos./}"
    attr_path="${attr_path//./\/}"
  elif [[ $attr_origpath == "hm."* ]]; then
    attr_path="${attr_origpath/hm./}"
    attr_path="users/${attr_path//./\/}"
  else
    echo "Please make sure your profile path starts with either 'nixos.' or 'hm.'!"
    exit 1
  fi

  printf "$attr_path"
}

# Parses source URLs like "owner/repo" or "gitlab:owner/repo"
# and turns them into a proper URL
function parse_sourceurl () {
  url="$1"

  if [[ $url == "github:"* ]]; then
    url="${url/"github:"/}"
    url="https://github.com/$url"
  elif [[ $url == "gitlab:"* ]]; then
    url="${url/"gitlab:"/}"
    url="https://gitlab.com/$url"
  elif [[ $url != "http"* ]]; then
    url="https://github.com/$url"
  fi

  printf "$url"
}

# Creates a repository path in the cache from an URL
function make_repo_path () {
  url="$1"

  repo_name="${url##*/}"
  repo_tmp="${url/\/$repo_name/}"
  repo_owner="${repo_tmp##*/}"

  printf "$GIT_CACHE/$repo_owner-$repo_name"
}

# Clones a repository into cache if it does not exist
# otherwise update the repository
function fetch_repo () {
  url="$1"
  repo_path="$2"

  mkdir -p "$repo_path"
  git clone --depth 1 "$url" "$repo_path" \
    || git --git-dir "$repo_path/.git" --work-tree "$repo_path" pull

  if [[ $? != 0 ]]; then
    echo "Failed to fetch '$url' with git, error code: $?"
    exit 2
  fi
}

function print_source_help () {
  echo "'source' can be either a git repository URL, 'github:owner/repo' or 'gitlab:owner/repo'"
  echo "if 'source' is given as 'owner/repo', it will default to 'github:owner/repo'"
}

function show_tree_without_default () {
  exa ${3} -Th "$1" | rg -v "(default\.nix|profiles|modules)" | tail -n +1 || echo "$2"
}

GIT_CACHE="$HOME/.cache/bud/git"

case "$1" in
  "show")
    shift 1

    url="$1"
    ty="$2"

    if [[ -z "$url" ]]; then
      echo "Show profiles / modules / users / hosts available in the specified source\n"
      echo "Usage: show source (profiles|users|hosts|modules)\n"
      print_source_help
      echo "if 'source' is '.', it will show your own profiles / users / hosts / modules\n"
      echo "if none of 'profiles', 'users', 'hosts' or 'modules' are specified, it will default to 'profiles'"
      exit 1
    fi

    if [[ "$url" == "." ]]; then
      repo_path="."
    else
      url=$(parse_sourceurl "$url")
      repo_path=$(make_repo_path "$url")

      fetch_repo "$url" "$repo_path" || exit $?
    fi

    case "$ty" in
      "users")
        echo "users:"
        show_tree_without_default "$repo_path/users" "no users found" "--level=1"
        ;;
      "hosts")
        echo "hosts:"
        show_tree_without_default "$repo_path/hosts" "no hosts found" "--level=1"
        ;;
      "modules")
        echo "nixos modules:"
        show_tree_without_default "$repo_path/modules" "no nixos profiles found"
        echo "home-manager modules:"
        show_tree_without_default "$repo_path/users/modules" "no home-manager profiles found"
        ;;
      *)
        echo "nixos profiles:"
        show_tree_without_default "$repo_path/profiles" "no nixos profiles found"
        echo "home-manager profiles:"
        show_tree_without_default "$repo_path/users/profiles" "no home-manager profiles found"
        ;;
    esac
    ;;
  "remove")
    shift 1

    attr_origpath=$1

    if [[ -z "$attr_origpath" ]]; then
      echo "Remove a profile / user / host / module from your config\n"
      echo "Usage: remove nixos.(profiles|users|hosts|modules).[NAME] / add source hm.(profiles|modules).[NAME]"
      exit 1
    fi

    attr_path=$(parse_attrpath "$attr_origpath") || exit $?

    if [[ -e "$attr_path" ]]; then
      rm -r "$attr_path"
      echo "deleted cfg '$attr_origpath'"
    else
      echo "cfg '$attr_origpath' does not exist in your config"
      exit 1
    fi
    ;;
  "add")
    shift 1

    url=$1
    attr_origpath=$2

    if [[ -z "$url" || -z "$attr_origpath" ]]; then
      echo "Add a profile / user / host / module from the specified source\n"
      echo "Usage: add source nixos.(profiles|users|hosts|modules).[NAME] / add source hm.(profiles|modules).[NAME]\n"
      print_source_help
      exit 1
    fi

    attr_path=$(parse_attrpath "$attr_origpath") || exit $?
    url=$(parse_sourceurl "$url")
    repo_path=$(make_repo_path "$url")
    repo_attr_path="$repo_path/$attr_path"

    fetch_repo "$url" "$repo_path" || exit $?

    if [[ -e "$repo_attr_path" ]]; then
      mkdir -p "$attr_path"
      cp -r "$repo_attr_path"/* "$attr_path/"
      echo "Added profile '$attr_origpath'!"
    else
      echo "Profile '$attr_origpath' does not exist in user repository!"
      exit 3
    fi
    ;;
  *)
    echo "Available subcommands are:"
    echo "  - 'add': Add a profile / user / host / module from the specified source"
    echo "  - 'show': Show profiles / users / hosts / modules available in the specified source"
    echo "  - 'remove': Remove a profile / user / host / module from your config\n"
    echo "run 'bud cfg command' for more info about a command"
    exit 1
    ;;
esac
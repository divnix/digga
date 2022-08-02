#!/usr/bin/env bash

if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=$(git hash-object -t tree /dev/null)
fi

diff="git diff-index --name-only --cached $against --diff-filter d"

mapfile -t nix_files < <($diff -- '*.nix')
mapfile -t all_files < <($diff)

# Format staged nix files
if (( ${#nix_files[@]} != 0 )); then
  # Stash only unstaged changes, keeping staged changes
  old_stash=$(git rev-parse --quiet --verify refs/stash)
  git stash push --quiet --keep-index -m 'Unstaged changes before pre-commit hook'
  new_stash=$(git rev-parse --quiet --verify refs/stash)

  # Format staged changes
  nixpkgs-fmt "${nix_files[@]}" \
  && git add "${nix_files[@]}"

  # If unstaged changes were stashed re-apply to working tree
  if [ "$old_stash" != "$new_stash" ]; then
      git stash pop --quiet
  fi
fi

# Check editorconfig
if (( ${#all_files[@]} != 0 )); then
  editorconfig-checker -- "${all_files[@]}"
fi

if [[ $? != '0' ]]; then
  printf "%b\n" \
    "\nCode is not aligned with .editorconfig" \
    "Review the output and commit your fixes" >&2
  exit 1
fi

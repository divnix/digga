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

# Format staged nix files.
if [[ -n "${nix_files[@]}" ]]; then
  # stash only unstaged changes, keeping staged changes
  old_stash=$(git rev-parse --quiet --verify refs/stash)
  git stash push --quiet --keep-index -m 'Unstaged changes before pre-commit hook'
  new_stash=$(git rev-parse --quiet --verify refs/stash)

  # format staged changes
  nixpkgs-fmt "${nix_files[@]}" \
  && git add "${nix_files[@]}"

  # if unstaged changes were stashed reapply to working tree
  if [ "$old_stash" != "$new_stash" ]; then
      git stash pop --quiet
  fi
fi

# check editorconfig
if ! editorconfig-checker -- "${all_files[@]}"; then
  printf "%b\n" \
    "\nCode is not aligned with .editorconfig" \
    "Review the output and commit your fixes" >&2
  exit 1
fi

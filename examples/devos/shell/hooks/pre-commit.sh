#!/usr/bin/env bash

if git rev-parse --verify HEAD >/dev/null 2>&1; then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=$(${git}/bin/git hash-object -t tree /dev/null)
fi

diff="git diff-index --name-only --cached $against --diff-filter d"

all_files=($($diff))

# Format staged files.
if ((${#all_files[@]} != 0)); then
  treefmt "${all_files[@]}" &&
    git add "${all_files[@]}"
fi

# check editorconfig
if ((${#all_files[@]} != 0)); then
  if ! editorconfig-checker -- "${all_files[@]}"; then
    printf "%b\n" \
      "\nCode is not aligned with .editorconfig" \
      "Review the output and commit your fixes" >&2
    exit 1
  fi
fi

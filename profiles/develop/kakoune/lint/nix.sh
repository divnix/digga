#!/usr/bin/env zsh

nix-linter -W all $1 2>&1 | < /dev/stdin > /tmp/lint.out
if head -1 /tmp/lint.out | grep Failure &> /dev/null; then
  sed -n 2p /tmp/lint.out | tr '\n' ' '
  printf "error: "
  awk 'NR>5 {printf "%s; ", $0}' /tmp/lint.out
else
  awk '{$(NF-1)=""; print $NF ": warning: " $0}' /tmp/lint.out > /tmp/lint.2
  awk '{$NF="";gsub(/-[0-9]*:[0-9]*:*/, ":"); print $0}' /tmp/lint.2
fi
rm -f /tmp/lint.out
rm -f /tmp/lint.2

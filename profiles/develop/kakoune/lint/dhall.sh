#!/usr/bin/env zsh

dhall lint --inplace $1 2>&1 | < /dev/stdin > /tmp/lint.out
if head -2 /tmp/lint.out | grep Error &> /dev/null; then
  sed -n 4p /tmp/lint.out | tr '\n' ' '
  sed -n 2p /tmp/lint.out | tr 'E' 'e' | tr '\n' ';' \
  | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"

  awk 'NR>7 {printf " %s", $0}' /tmp/lint.out
else
  true
fi
rm -f /tmp/lint.out

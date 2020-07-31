{ pkgs, ... }:
let inherit (pkgs) alsaUtils bash gnugrep volnoti;
in
pkgs.writeScript "volnoti.sh" ''
  #!${bash}/bin/bash

  declare -i current=$(${alsaUtils}/bin/amixer get Master | ${gnugrep}/bin/grep -m1 -Po "[0-9]+(?=%)")
  if [[ $current -gt 100 ]]; then
    current=100
  fi


  if ${alsaUtils}/bin/amixer get Master | ${gnugrep}/bin/grep -Fq "[off]"; then
    ${volnoti}/bin/volnoti-show -m $current
  else
    ${volnoti}/bin/volnoti-show $current
  fi
''

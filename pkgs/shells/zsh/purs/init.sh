function zle-line-init zle-keymap-select {
  if [[ $USER == root ]]; then
    PROMPT=`@PURS@/bin/purs prompt -u -k "$KEYMAP" -r "$?" --venv "${${VIRTUAL_ENV:t}%-*}"`
  else
    PROMPT=`@PURS@/bin/purs prompt -us -k "$KEYMAP" -r "$?" --venv "${${VIRTUAL_ENV:t}%-*}"`
  fi
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

autoload -Uz add-zsh-hook

function _prompt_purs_precmd() {
  @PURS@/bin/purs precmd
}
add-zsh-hook precmd _prompt_purs_precmd

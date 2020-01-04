while read line; do line=${(Q)line}; [[ -d $line ]] && echo $line; done < $HOME/.cache/zsh-cdr/recent-dirs

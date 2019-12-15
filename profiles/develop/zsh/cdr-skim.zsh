while read line; do line=${(Q)line}; [[ -d $line ]] && echo $line; done < /home/nrd/.cache/zsh-cdr/recent-dirs

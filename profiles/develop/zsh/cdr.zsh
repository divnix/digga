if [[ -z "$ZSH_CDR_DIR" ]]; then
    ZSH_CDR_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh-cdr
fi
mkdir -p $ZSH_CDR_DIR
autoload -Uz chpwd_recent_dirs cdr
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file $ZSH_CDR_DIR/recent-dirs
zstyle ':chpwd:*' recent-dirs-max 1000
# fall through to cd
zstyle ':chpwd:*' recent-dirs-default yes

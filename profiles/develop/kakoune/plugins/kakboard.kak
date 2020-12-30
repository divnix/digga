
declare-option -docstring 'command to copy to clipboard' \
    str kakboard_copy_cmd

declare-option -docstring 'command to paste from clipboard' \
    str kakboard_paste_cmd

declare-option -docstring 'keys to pull clipboard for' \
    str-list kakboard_paste_keys p P R <a-p> <a-P> <a-R>

declare-option -docstring 'keys to copy to clipboard' \
    str-list kakboard_copy_keys y c d

declare-option -hidden bool kakboard_enabled false

define-command -docstring 'copy system clipboard into the " register' \
        kakboard-pull-clipboard %{ evaluate-commands %sh{
    # Shell expansions are stripped of new lines, so the output of the
    # command has to be wrapped in quotes (and its quotes escaped)
    #
    # (All of this quoting and escaping really messes up kakoune's syntax
    # highlighter)
    if test -n "$kak_opt_kakboard_paste_cmd"; then
        printf 'set-register dquote %s' \
            "'$($kak_opt_kakboard_paste_cmd | sed -e "s/'/''/g"; echo \')"
    else
        echo "echo -debug 'kakboard: kakboard_paste_cmd not set'"
    fi
}}

define-command -docstring 'copy system clipboard if current register is unset' \
        kakboard-pull-if-unset %{ evaluate-commands %sh{
    if test -z "$kak_register"; then
        echo "kakboard-pull-clipboard"
    fi
}}

# Pull the clipboard and execute the key with the same context
define-command -docstring 'copy system clipboard then execute keys' \
  kakboard-with-pull-clipboard -params 1 %{
    kakboard-pull-if-unset
    evaluate-commands %sh{
        if test -n "$kak_register"; then
            register="\"$kak_register"
        fi
        echo "execute-keys -with-hooks -save-regs '' '$register$kak_count$1'"
    }
}

define-command -docstring 'set system clipboard from the " register' \
        kakboard-push-clipboard %{ nop %sh{
    # The copy command is executed and forked in a subshell because some
    # commands (looking at you, xclip and wl-copy) block when executed by
    # kakoune normally
    if test -n "$kak_opt_kakboard_copy_cmd"; then
        printf '%s' "$kak_main_reg_dquote" \
            | ($kak_opt_kakboard_copy_cmd) >/dev/null 2>&1 &
    else
        echo "echo -debug 'kakboard: kakboard_copy_cmd not set'"
    fi
}}

define-command -docstring 'set system clipboard if current register is unset' \
        kakboard-push-if-unset %{ evaluate-commands %sh{
    if test -z "$kak_register"; then
        echo "kakboard-push-clipboard"
    fi
}}

# Set the clipboard and execute the key with the same context
define-command -docstring 'execute keys then set system clipboard' \
  kakboard-with-push-clipboard -params 1 %{
    evaluate-commands %sh{
        if test -n "$kak_register"; then
            register="\"$kak_register"
        fi
        # Don't preserve registers since we want the same behavior as just
        # executing the keys (and don't want to preseve the " register)
        echo "execute-keys -with-hooks -save-regs '' '$register$kak_count$1'"
    }
    # Has to be outside of the sh expansion so that the register environment
    # variable will update
    kakboard-push-if-unset
}

define-command -hidden kakboard-autodetect %{
    evaluate-commands %sh{
        # Don't override if there are already commands
        if test -n "$kak_opt_kakboard_copy_cmd" -o \
            -n "$kak_opt_kakboard_paste_cmd"
        then
            exit
        fi

        copy=
        paste=
        case $(uname -s) in
            Darwin)
                copy="pbcopy"
                paste="pbpaste"
                ;;

            *)
                if test -n "$WAYLAND_DISPLAY" \
                    && command -v wl-copy >/dev/null \
                    && command -v wl-paste >/dev/null
                then
                    # wl-clipboard
                    copy="wl-copy --foreground"
                    paste="wl-paste --no-newline"
                elif test -n "$DISPLAY" && command -v xsel >/dev/null; then
                    # xsel
                    copy="xsel --input --clipboard"
                    paste="xsel --output --clipboard"
                elif test -n "$DISPLAY" && command -v xclip >/dev/null; then
                    # xclip
                    copy="xclip -in -selection clipboard"
                    paste="xclip -out -selection clipboard"
                fi
                ;;
        esac

        echo "set-option global kakboard_copy_cmd '$copy'"
        echo "set-option global kakboard_paste_cmd '$paste'"
    }
}

define-command -docstring 'enable clipboard integration' kakboard-enable %{
    set-option window kakboard_enabled true
    kakboard-autodetect

    evaluate-commands %sh{
        if test -z "$kak_opt_kakboard_copy_cmd" -o \
            -z "$kak_opt_kakboard_paste_cmd"
        then
            echo "echo -debug 'kakboard: Could not auto-detect clipboard commands. Please set them explicitly.'"
        fi

        # Still make the bindings so that they can be set later

        eval set -- "$kak_quoted_opt_kakboard_paste_keys"
        while test $# -gt 0; do
            escaped=$(echo "$1" | sed -e 's/</<lt>/')
            echo map global normal "$1" \
                "': kakboard-with-pull-clipboard $escaped<ret>'"
            shift
        done

        eval set -- "$kak_quoted_opt_kakboard_copy_keys"
        while test $# -gt 0; do
            escaped=$(echo "$1" | sed -e 's/</<lt>/')
            echo map global normal "$1" \
                "': kakboard-with-push-clipboard $escaped<ret>'"
            shift
        done
    }
}

define-command -docstring 'disable clipboard integration' kakboard-disable %{
    set-option window kakboard_enabled false

    remove-hooks window kakboard

    evaluate-commands %sh{
        eval set -- "$kak_quoted_opt_kakboard_paste_keys" \
                    "$kak_quoted_opt_kakboard_copy_keys"
        while test $# -gt 0; do
            echo unmap global normal "$1"
            shift
        done
    }
}

define-command -docstring 'toggle clipboard integration' kakboard-toggle %{
    evaluate-commands %sh{
        if test "$kak_opt_kakboard_enabled" = true; then
            echo "kakboard-disable"
        else
            echo "kakboard-enable"
        fi
    }
}

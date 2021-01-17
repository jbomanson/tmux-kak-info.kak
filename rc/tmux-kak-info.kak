hook global ModuleLoaded tmux %{
    require-module tmux-kak-info
}

provide-module tmux-kak-info %~

define-command tmux-kak-info-set \
    -hidden \
%(
    nop %sh(
        test "$TMUX" || exit
        assign () {
            # man tmux:
            #  -v shows only the option value, not the name.
            local e="$(tmux show-option -v "$@" @kak_info_sessions)"
            local v="$(
                if test -n "$e"; then
                    printf "%s\n" "$e"
                fi
                if ! printf "%s\n" "$e" | grep -qF "$kak_session"; then
                    printf "%s\n" "$kak_session"
                fi
            )"
            local s='tmux set-option "$@" @kak_info_sessions "$v"'
            if ! eval "$s"; then
                >&2 printf "%s\n" \
                    "tmux-kak-info: failed to call $s"
            fi
        }
        assign    # Update session option.
        assign -w # Update window option.
    )
)

evaluate-commands %sh(
    for client in $kak_client_list
    do
        printf 'evaluate-commands -client "%s" tmux-kak-info-set\n' "$client"
    done
)

hook global ClientCreate .* tmux-kak-info-set

hook global KakEnd .* %(
    nop %sh(
        test "$TMUX" || exit
        unassign () {
            # man tmux:
            #  -v shows only the option value, not the name.
            local v="$(
                tmux show-option -v "$@" @kak_info_sessions \
                    | grep -vE "^$kak_session\$"
            )"
            if test "$v"; then
                local s='tmux set-option "$@" @kak_info_sessions "$v"'
            else
                local s='tmux set-option -u "$@" @kak_info_sessions'
            fi
            if ! eval "$s"; then
                >&2 printf "%s\n" \
                    "tmux-kak-info: failed to call $s"
            fi
        }
        unassign    # Update session option.
        unassign -w # Update window option.
    )
)

~

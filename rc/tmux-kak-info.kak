hook global ModuleLoaded tmux %{
    require-module tmux-kak-info
}

provide-module tmux-kak-info %~

hook global ClientCreate .* %(
    nop %sh(
        test "$TMUX" || exit
        assign () {
            # man tmux:
            #  -v shows only the option value, not the name.
            local v="$(
                tmux show-option -v "$@" @kak_info_sessions
                printf "%s" "$kak_session"
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

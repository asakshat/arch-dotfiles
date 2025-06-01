#!/usr/bin/env bash

TMP_ACTION_FILE="/tmp/.tmux_session_action"

list_sessions() {
    tmux list-sessions -F "#{session_name}|#{session_windows}|#{session_attached}" 2>/dev/null || echo "no_sessions|0|0"
}

select_session() {
    list_sessions | \
        column -t -s '|' | \
        fzf --prompt="Tmux Sessions > " \
            --preview="tmux list-windows -t {1} 2>/dev/null || echo 'No windows'" \
            --header=$'Enter: attach | Alt-N: new | Alt-R: rename | Alt-D: delete' \
            --bind "alt-N:execute-silent(echo new > $TMP_ACTION_FILE)+abort" \
            --bind "alt-R:execute-silent(echo rename:{1} > $TMP_ACTION_FILE)+abort" \
            --bind "alt-D:execute-silent(echo delete:{1} > $TMP_ACTION_FILE)+abort"
}

create_new_session() {
    read -p "Enter new session name: " session_name
    if [[ -n "$session_name" ]]; then
        tmux new-session -d -s "$session_name"
        tmux switch-client -t "$session_name" 2>/dev/null || tmux attach-session -t "$session_name"
    fi
}

rename_session() {
    local old_name="$1"
    read -p "Rename session '$old_name' to: " new_name
    if [[ -n "$new_name" ]]; then
        tmux rename-session -t "$old_name" "$new_name"
    fi
}

delete_session() {
    local session_name="$1"
    echo "Kill session '$session_name'? (y/n)"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        tmux kill-session -t "$session_name"
    fi
}

main() {
    # Clean up any existing action file
    [[ -f "$TMP_ACTION_FILE" ]] && rm "$TMP_ACTION_FILE"

    # Check if tmux is running
    if ! tmux list-sessions &>/dev/null; then
        echo "No tmux sessions found. Creating new session..."
        create_new_session
        return
    fi

    selected=$(select_session)
    action=""

    # Check if an action was triggered
    if [[ -f "$TMP_ACTION_FILE" ]]; then
        action=$(<"$TMP_ACTION_FILE")
        rm "$TMP_ACTION_FILE"
    fi

    case "$action" in
        new)
            create_new_session
            ;;
        rename:*)
            session_name="${action#rename:}"
            # Remove any extra whitespace
            session_name=$(echo "$session_name" | xargs)
            rename_session "$session_name"
            ;;
        delete:*)
            session_name="${action#delete:}"
            # Remove any extra whitespace
            session_name=$(echo "$session_name" | xargs)
            delete_session "$session_name"
            ;;
        *)
            if [[ -n "$selected" && "$selected" != "no_sessions" ]]; then
                session_name=$(echo "$selected" | awk '{print $1}')
                if tmux list-sessions -F "#{session_name}" | grep -q "^${session_name}$"; then
                    tmux switch-client -t "$session_name" 2>/dev/null || tmux attach-session -t "$session_name"
                fi
            fi
            ;;
    esac
}

main "$@"

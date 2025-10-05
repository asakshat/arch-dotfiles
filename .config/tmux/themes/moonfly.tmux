# --- Theme Appearance ---
set -g status on
set -g status-interval 2
set -g status-style bg=default,fg=white

# --- Left side: [ 0:zsh] ---
set -g status-left-length 100
set -g status-left '#[fg=black,bg=cyan]  #I:#W #[default]'

# --- Remove center window list ---
set -g window-status-format ''
set -g window-status-current-format ''

# --- Right side: [ session] [ path] ---
set -g status-right-length 150
set -g status-right '#[fg=cyan] #S #[fg=magenta] #{pane_current_path} '

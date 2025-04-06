# Disable greeting
set fish_greeting
fish_vi_key_bindings

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

# path
fish_add_path -a ~/.local/bin/

# previous and next command
bind \cp up-or-search
bind \cn down-or-search
# and in vim insert mode
bind -s -M insert \cp up-or-search
bind -s -M insert \cn down-or-search

bind -M normal \cf "~/.config/scripts/tmux_sessionizer.sh"
bind -M insert \cf "~/.config/scripts/tmux_sessionizer.sh"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Ssh-agent
if test -z (pgrep ssh-agent | string collect)
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

# zoxide
zoxide init fish | source

# init prompt
starship init fish | source

# alias
if command -v eza >/dev/null 2>&1
    alias ls="eza -l"
else if command -v exa >/dev/null 2>&1
    alias ls="exa -l"
end
if command -v bat >/dev/null 2>&1
    alias cat="bat"
end

if command -v vim >/dev/null 2>&1
    export MANROFFOPT="-c"
    export MANPAGER="sh -c 'col -bx | vim -'"
end

if command -v tmux >/dev/null 2>&1
    alias ts="~/.config/scripts/tmux_sessionizer.sh"
end

alias em="TERM=xterm-direct emacsclient -s null -nw ./"

# feh
alias feh="feh --draw-filename -B 'black' --scale-down -R 5"

# pyenv
if command -v pyenv > /dev/null 2>&1
    status --is-interactive; and pyenv init - | source
    status --is-interactive; and pyenv virtualenv-init - | source
end

# Work config
set work_config_file "$HOME/.config/fish_work/conf.d/work.fish"
if test -f $work_config_file
    source $work_config_file
end

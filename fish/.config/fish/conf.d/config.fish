# Disable greeting
set fish_greeting
fish_vi_key_bindings

# Accept autocompletion with alt tab
# src: https://github.com/fish-shell/fish-shell/issues/3011
bind -M insert \e\t accept-autosuggestion

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

# previous and next command
bind \cp up-or-search
bind \cn down-or-search
# and in vim insert mode
bind -s -M insert \cp up-or-search
bind -s -M insert \cn down-or-search

# zoxide
zoxide init fish | source

# init prompt
starship init fish | source

# alias
if command -v nvim >/dev/null 2>&1
    alias vim="nvim"
end
alias ssh="kitty +kitten ssh"
# If exa is installed
if command -v exa >/dev/null 2>&1
    alias ls="exa -l"
end
# If bat is installed
if command -v bat >/dev/null 2>&1
    alias cat="bat"
    # use bat for man
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
end

# pyenv
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source


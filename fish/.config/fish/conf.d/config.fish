
# Vi bindings for colemak (hacked together)
bind -s m backward-char
bind -s n down-or-search
bind -s e up-or-search
bind -s i forward-char
bind -s -m insert l repaint-mode
bind -s -m insert L beginning-of-line repaint-mode

# previous and next command
bind \cp up-or-search
bind \cn down-or-search

# autojump
begin
    set --local AUTOJUMP_PATH $HOME/.autojump/share/autojump/autojump.fish
    if test -e $AUTOJUMP_PATH
        source $AUTOJUMP_PATH
    end
end

starship init fish | source

# Disable greeting
set fish_greeting

# Vi bindings for colemak (hacked together)
bind -s m backward-char
bind -s n down-or-search
bind -s e up-or-search
bind -s i forward-char
bind -s -m insert l repaint-mode
bind -s -m insert L beginning-of-line repaint-mode
bind -s -M visual m backward-char
bind -s -M visual i forward-char
bind -s -M visual n up-line
bind -s -M visual e down-line

# Accept autocompletion with alt a
# src: https://github.com/fish-shell/fish-shell/issues/3011
bind -M insert \ea accept-autosuggestion

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

# autojump
begin
    set --local AUTOJUMP_PATH $HOME/.autojump/share/autojump/autojump.fish
    if test -e $AUTOJUMP_PATH
        source $AUTOJUMP_PATH
    end
end

# init prompt
starship init fish | source

# source ansi colors
set -U fish_color_autosuggestion      brblack
set -U fish_color_cancel              -r
set -U fish_color_command             brgreen
set -U fish_color_comment             brmagenta
set -U fish_color_cwd                 green
set -U fish_color_cwd_root            red
set -U fish_color_end                 brmagenta
set -U fish_color_error               brred
set -U fish_color_escape              brcyan
set -U fish_color_history_current     --bold
set -U fish_color_host                normal
set -U fish_color_match               --background=brblue
set -U fish_color_normal              normal
set -U fish_color_operator            cyan
set -U fish_color_param               brblue
set -U fish_color_quote               yellow
set -U fish_color_redirection         bryellow
set -U fish_color_search_match        'bryellow' '--background=brblack'
set -U fish_color_selection           'white' '--bold' '--background=brblack'
set -U fish_color_status              red
set -U fish_color_user                brgreen
set -U fish_color_valid_path          --underline
set -U fish_pager_color_completion    normal
set -U fish_pager_color_description   yellow
set -U fish_pager_color_prefix        'white' '--bold' '--underline'
set -U fish_pager_color_progress      'brwhite' '--background=cyan'

# alias
alias ls="exa -l"
alias cat="bat"
alias doom="~/.emacs.d/bin/doom"

# pyenv
status is-login; and pyenv init --path | source
pyenv init - | source

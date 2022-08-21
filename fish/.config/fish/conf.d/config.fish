# Disable greeting
set fish_greeting
fish_vi_key_bindings

# Vi bindings for colemak (hacked together)
# bind -s m backward-char
# bind -s n down-or-search
# bind -s e up-or-search
# bind -s i forward-char
# bind -s -m insert l repaint-mode
# bind -s -m insert L beginning-of-line repaint-mode
# bind -s -M visual m backward-char
# bind -s -M visual i forward-char
# bind -s -M visual n up-line
# bind -s -M visual e down-line

# Accept autocompletion with alt a
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
alias s="kitty +kitten ssh"
#alias ls="exa -l"
#alias cat="bat"
#alias doom="~/.emacs.doom/bin/doom"

# Work aliase
# function brun
#     build -clin $argv[1] && $WS_ROOT/build/Linux_x86_64/bin/$argv[1]/$argv[1]_Linux_x86_64.elf $argv[2]
# end

# function bgrind
#     build -clin $argv[1] && valgrind --tool=memcheck --leak-check=full --leak-resolution=high --error-exitcode=99 $WS_ROOT/build/Linux_x86_64/bin/$argv[1]/$argv[1]_Linux_x86_64.elf $argv[2]
# end

# function bgdb
#     build -clin.debug $argv[1] && gdb --args $WS_ROOT/build/Linux_x86_64.debug/bin/$argv[1]/$argv[1]_Linux_x86_64.debug.elf -v $argv[2]
# end

# function bclang
#     build -Dclin.clangsan $argv[1] && $WS_ROOT/build/Linux_x86_64.clangsan/bin/$argv[1]/$argv[1]_Linux_x86_64.clangsan.elf $argv[2]
# end

# use bat for man
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# pyenv
# status --is-interactive; and pyenv init - | source
# status --is-interactive; and pyenv virtualenv-init - | source

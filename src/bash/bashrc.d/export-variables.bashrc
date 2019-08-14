#!/usr/bin/env bash
# vim: set filetype=sh

# My Profile
export EMAIL="edentsai231@gmail.com"
export FULL_NAME="Eden Tsai"
export NICK_NAME="Eden"
export TMUX_RESURRECT_DIR_CATEGORY="$HOSTNAME"
export TMUX_TMPDIR="$HOME/.tmux/tmp"

# Locale, Terminal, Editor and Pager
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="screen-256color"
export EDITOR="vim"
export GIT_PAGER="less"

# Export variables for the 'ls' command.
#   BLOCKSIZE | The block size in bytes by the -l and -s options.
#   CLICOLOR  | Use ANSI color sequences to distinguish file types.
#   LSCOLORS  | Describes what color to use for which attribute when colors are enabled with CLICOLOR,
#             | the origin setting of LSCOLORS is "Dxfxcxdxbxegedabagacad".
export BLOCKSIZE="K"
export CLICOLOR=1
case $(uname -s) in
    "FreeBSD")
        export LSCOLORS="ExfxcxdxbxEgEdabagacad"
        ;;
    "Darwin")
        export LSCOLORS="ExfxcxdxbxEgEdabagacad"
        ;;
    "Linux")
        ;;
esac

# Export variables for the 'man' command.
#   MANPAGER | Program used to display files.
export MANPAGER="less -Is"

# Use 'most' command as MANPAGER better if it exists.
most_path=`which most`
if [ -f "$most_path" ]; then
    export MANPAGER="most -s"
fi

# MySQL Prompt
export MYSQL_PS1="[\u@\h] : (\d)\n[\R:\m:\s] mysql> "

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

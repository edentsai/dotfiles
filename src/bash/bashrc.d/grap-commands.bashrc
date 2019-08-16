#!/usr/bin/env bash
# vim: set filetype=sh

# Bash configuration for `grep`, `egrep`, `fgrep` commands.
function bashrc::configure_grep_commands()
{
    alias grep="grep --color=auto --directories=skip --exclude=\.swp --exclude=\.svn --exclude=\.git"
    alias egrep="egrep --color=auto --directories=skip --exclude=\.swp --exclude=\.svn --exclude=\.git"
    alias fgrep="fgrep --color=auto --directories=skip --exclude=\.swp --exclude=\.svn --exclude=\.git"
}

bashrc::configure_grep_commands

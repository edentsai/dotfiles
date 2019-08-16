#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `man` command.
bashrc::configure_man_command()
{
    # List $MANPATH and force output to be one entry per line.
    alias manpath="echo -e \${MANPATH//:/\\\n}"

    # MANPAGER: Program used to display files.
    # Use `less` command as default man pager if `less` command is installed.
    if command -v less > /dev/null; then
        export MANPAGER="less -Is"
    fi

    # Use `most` command as man pager better if `most` command is installed.
    if command -v most > /dev/null; then
        export MANPAGER="most -s"
    fi
}

bashrc::configure_man_command

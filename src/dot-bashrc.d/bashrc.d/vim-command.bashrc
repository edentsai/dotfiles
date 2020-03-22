#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure aliases for `vim` command.
bashrc::configure_vim_command()
{
    # Vim open last edited file.
    alias vimlast="vim -c \"normal '0\""

    # Open Vim faster without plugins.
    alias vimfast="vim --noplugin"
}

bashrc::configure_vim_command

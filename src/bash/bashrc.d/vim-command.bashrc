#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `vim` command.
function bashrc::configure_vim_command()
{
    # Vim open last edited file.
    alias vimlast="vim -c \"normal '0\""

    # Open Vim faster without plugins
    alias vimfast="vim --noplugin"
}

bashrc::configure_vim_command

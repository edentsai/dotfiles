#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `cd` command.
function bashrc::configure_cd_command()
{
    # Change directory quickly.
    alias ..="cd .."
    alias ...="cd ../.."
    alias cd..="cd .."
    alias cd...="cd ../.."
    alias cd-="cd -"
}

bashrc::configure_cd_command

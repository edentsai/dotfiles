#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `ps` command.
function bashrc::configure_ps_command()
{
    # Display process status with more information.
    #   -u | Display more information
    #   -a | Display information about other users' processes as well as your own.
    #   -x | include processes which do not have a controlling terminal.
    alias psu="ps -u"
    alias psmem='ps -aux | sort -nr -k 4'
    alias psmem10='psmem | head -n 10'
    alias pscpu='ps -aux | sort -nr -k 3'
    alias pscpu10='pscpu | head -n 10'
}

bashrc::configure_ps_command

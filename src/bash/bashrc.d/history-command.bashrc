#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `history` command.
bashrc::configure_history_command()
{
    # Ignore duplicate commands or commands that have leading whitespace.
    export HISTCONTROL="ignoredups:ignorespace"

    # Display the time stamp information associated with each history entry.
    export HISTTIMEFORMAT="%F %T	"

    # The number of lines or commands that are stored in memory in a history list.
    export HISTSIZE="1000"

    # The name of the file to which the command history is saved. The default is `~/.bash_history'.
    local readonly username=$(whoami)
    local readonly hostname=$(hostname)
    export HISTFILE="${HOME}/.bash/tmp/histories/${hostname}/bash-history-${username}"

    # Init HISTFILE if not exist and writable.
    if ! test -w "${HISTFILE}"; then
        local readonly HISTFILE_DIR=$(dirname "${HISTFILE}")
        mkdir -v -p "${HISTFILE_DIR}"
        chmod 600 "${HISTFILE_DIR}"

        touch "${HISTFILE}"
        chmod 600 "${HISTFILE}"
    fi
}

bashrc::configure_history_command

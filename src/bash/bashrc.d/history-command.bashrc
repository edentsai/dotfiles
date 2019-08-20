#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `history` command.
function bashrc::configure_history_command()
{
    # Set to append bash commands to History file, not overwrites.
    shopt -s histappend

    # Store multi-line commands in one history entry
    shopt -s cmdhist

    # Ignore duplicate commands or commands that have leading whitespace.
    export HISTCONTROL="ignoredups:ignorespace"

    # Display the time stamp information associated with each history entry
    export HISTTIMEFORMAT='%Y-%m-%dT%H:%M:%S%z    '

    # The number of lines or commands that are stored in memory in a history list.
    export HISTSIZE="1000"

    # Ignore specific commands.
    export HISTIGNORE="history"


    # Store Bash History Immediately.
    # By default, Bash only records a session to the HISTFILE file when the session terminates.
    # export PROMPT_COMMAND="history -a"

    # The name of the file to which the command history is saved. The default is `~/.bash_history'.
    local readonly username=$(whoami)
    local readonly hostname=$(hostname)
    export HISTFILE="${HOME}/.bash/tmp/histories/${hostname}/bash-history-${username}"

    # Init HISTFILE if not exist and writable.
    if ! test -w "${HISTFILE}"; then
        local readonly HISTFILE_DIR=$(dirname "${HISTFILE}")
        mkdir -v -p "${HISTFILE_DIR}"
        chmod 750 "${HISTFILE_DIR}"

        touch "${HISTFILE}"
        chmod 750 "${HISTFILE}"
    fi
}

bashrc::configure_history_command

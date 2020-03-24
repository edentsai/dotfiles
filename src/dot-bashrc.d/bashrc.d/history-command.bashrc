#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi


# Configure shell options and env variables for `history` command.[
bashrc::configure_history_command()
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
    local username
    local hostname
    username="$(id -un)"
    hostname="$(hostname)"
    export HISTFILE="${HOME}/.bashrc.d/histories/.bash_history_${username}_${hostname}"

    # Init HISTFILE if not exist or not writable.
    if ! test -w "${HISTFILE}"; then
        local histfile_dir
        histfile_dir="$(dirname "${HISTFILE}")"

        mkdir -v -p "${histfile_dir}"
        chmod 750 "${histfile_dir}"

        touch "${HISTFILE}"
        chmod 750 "${HISTFILE}"
    fi
}

bashrc::configure_history_command
bashrc::create_history_file_if_not_exists "${HISTFILE}"

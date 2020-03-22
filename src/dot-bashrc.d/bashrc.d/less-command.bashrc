#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure env variables for `less` command.
bashrc::configure_less_command()
{
    # Options which are passed to less automatically.
    export LESS="-emrSwX"

    # The maximum number of commands to save in the history file.
    export LESSHISTSIZE="100"

    # The history file used to remember search commands and shell commands between invocations of less.
    local username
    local hostname
    username="$(id -un)"
    hostname="$(hostname)"
    export LESSHISTFILE="${HOME}/.bashrc.d/histories/.lesshst_${username}_${hostname}"
}

bashrc::configure_less_command
bashrc::create_history_file_if_not_exists "${LESSHISTFILE}"

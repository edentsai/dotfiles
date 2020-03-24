#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure env variables for `mycli` command.
bashrc::configure_mycli_command()
{
    # Specify where to write the mycli history file.
    local username
    local hostname
    username="$(id -un)"
    hostname="$(hostname)"
    export MYCLI_HISTFILE="${HOME}/.bashrc.d/histories/.mycli_history_${username}_${hostname}"
}

bashrc::configure_mycli_command
bashrc::create_history_file_if_not_exists "${MYCLI_HISTFILE}"

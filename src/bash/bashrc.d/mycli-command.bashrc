#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `mycli` command.
bashrc::configure_mycli_command()
{
    # Specify where to write the mycli history file.
    local readonly username=$(whoami)
    local readonly hostname=$(hostname)
    export MYCLI_HISTFILE="${HOME}/.mycli/tmp/mycli-history-${hostname}-${username}"

    # Init MYCLI_HISTFILE if not exist and writable.
    if ! test -w "${MYCLI_HISTFILE}"; then
        local readonly MYCLI_HISTFILE_DIR=$(dirname "${MYCLI_HISTFILE}")
        mkdir -v -p "${MYCLI_HISTFILE_DIR}"
        chmod 600 "${MYCLI_HISTFILE_DIR}"

        touch "${MYCLI_HISTFILE}"
        chmod 600 "${MYCLI_HISTFILE}"
    fi
}

bashrc::configure_mycli_command

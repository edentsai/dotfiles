#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `less` command.
bashrc::configure_less_command()
{
    # Options which are passed to less automatically.
    export LESS="-emrSwX"

    # The maximum number of commands to save in the history file.
    export LESSHISTSIZE="100"

    # The history file used to remember search commands and shell commands between invocations of less.
    local readonly username=$(whoami)
    local readonly hostname=$(hostname)
    export LESSHISTFILE="${HOME}/.bash/tmp/histories/${hostname}/lesshst-${username}"

    # Init LESSHISTFILE if not exist.
    if ! test -f "${LESSHISTFILE}"; then
        local readonly LESSHISTFILE_DIR=$(dirname "${LESSHISTFILE}")
        mkdir -v -p "${LESSHISTFILE_DIR}"
        chmod 750 "${LESSHISTFILE_DIR}"

        touch "${LESSHISTFILE}"
        chmod 750 "${LESSHISTFILE}"
    fi
}

bashrc::configure_less_command

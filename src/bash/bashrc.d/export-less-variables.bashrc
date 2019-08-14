#!/usr/bin/env bash
# vim: set filetype=sh
#
# Less options: export variables for the 'less' command.
#   LESS         | Options which are passed to less automatically.
#   LESSHISTSIZE | The maximum number of commands to save in the history file.
#   LESSHISTFILE | The history file used to remember search commands and shell commands between invocations of less.
#

export LESS="-emrSwX"
export LESSHISTSIZE="100"

username=$(whoami)
export LESSHISTFILE="$HOME/.bash/tmp/histories/$HOSTNAME/lesshst-${username}"
unset username

# Init LESSHISTFILE if not exist.
if ! test -f "${LESSHISTFILE}"; then
    dir=$(dirname "${LESSHISTFILE}")
    mkdir -v -p -m 600 "${dir}"
    unset dir

    touch "${LESSHISTFILE}"
    chmod 600 "${LESSHISTFILE}"
fi

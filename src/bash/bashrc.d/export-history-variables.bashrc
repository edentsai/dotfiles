#!/usr/bin/env bash
# vim: set filetype=sh
#
# History options: export variables for the 'history' command.
#   HISTCONTROL    | Ignore duplicate commands or commands that have leading whitespace.
#   HISTFILE       | The name of the file to which the command history is saved. The default is `~/.bash_history'.
#   HISTTIMEFORMAT | Display the time stamp information associated with each history entry.
#   HISTSIZE       | The number of lines or commands that are stored in memory in a history list.
#

export HISTCONTROL="ignoredups:ignorespace"
export HISTTIMEFORMAT="%F %T	"
export HISTSIZE="1000"

username=$(whoami)
export HISTFILE="${HOME}/.bash/tmp/histories/${HOSTNAME}/bash-history-${username}"
unset username

# Init HISTFILE if not exist.
if ! test -f "${HISTFILE}"; then
    dir=$(dirname "${HISTFILE}")
    mkdir -v -p -m 600 "${dir}"
    unset dir

    touch "${HISTFILE}"
    chmod 600 "${HISTFILE}"
fi

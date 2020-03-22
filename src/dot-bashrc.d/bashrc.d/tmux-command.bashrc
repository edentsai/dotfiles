#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Bashrc configuration for `tmux` command.
# Configure env variables and aliases for `tmux` command
bashrc::configure_tmux_command()
{
    # tmux stores the server socket in a directory under TMUX_TMPDIR or /tmp if it is unset
    local hostname
    hostname="$(hostname)"
    export TMUX_TMPDIR="${HOME}/.tmux.conf.d/tmp/${hostname}"
    if ! test -d "${TMUX_TMPDIR}"; then
        mkdir -v -p "${TMUX_TMPDIR}"
    fi

    # FIXME Confirm this is avaiable
    # @see https://github.com/tmux-plugins/tmux-resurrect
    export TMUX_RESURRECT_DIR_CATEGORY="${hostname}"

    # Include local libevent.
    local library_paths="${HOME}/opt/libevent/lib:${LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH="${library_paths#:}"

    # Tmux force to assume the terminal supports 256 colours.
    alias tmux="tmux -2"
}

bashrc::configure_tmux_command

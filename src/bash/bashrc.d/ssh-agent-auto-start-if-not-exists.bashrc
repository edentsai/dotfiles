#!/usr/bin/env bash
# vim: set filetype=sh

# Auto start ssh-agent if not exists,
# also set a trap to auto kill ssh-agent on EXIT.
bashrc::ssh_agent_auto_start_if_not_exists()
{
    # Auto start ssh-agent if not exist,
    # and set a trap for auto stop ssh-agent on exit.
    if test "${PS1:-}" != "" \
        && test "${TMUX:-}" == "" \
        && test "${SSH_AGENT_PID:-}" == "" \
        && command -v ssh-agent > /dev/null;
    then \
        eval `ssh-agent -s`
        trap 'test "${TMUX:-}" == "" && test "${SSH_AGENT_PID:-}" != "" && eval `ssh-agent -k`' EXIT
    fi
}

bashrc::ssh_agent_auto_start_if_not_exists

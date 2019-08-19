#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `ssh` command.
function bashrc::configure_ssh_command()
{
    local ssh_control_dir
    readonly ssh_control_dir="${HOME}/.ssh/control"
    if ! test -d "${ssh_control_dir}"; then
        mkdir -v -p "${ssh_control_dir}";
    fi
}

# Auto start ssh-agent if not exists,
# also set a trap to auto kill ssh-agent on EXIT.
function bashrc::ssh_agent_auto_start_if_not_exists()
{
    # Auto start ssh-agent if not exist,
    # and set a trap for auto stop ssh-agent on exit.
    if test "${PS1:-}" != "" \
        && test "${TMUX_PANE:-}" == "" \
        && test "${SSH_AUTH_SOCK:-}" == "" \
        && test "${SSH_AGENT_PID:-}" == "" \
        && command -v ssh-agent > /dev/null;
    then \
        echo "Auto start a ssh-agent: "
        eval "$(ssh-agent -s)"
        trap 'test "${TMUX:-}" == "" && test "${SSH_AGENT_PID:-}" != "" && eval "$(ssh-agent -k)"' EXIT
    fi

    if test -d "${HOME}/.ssh" \
        && test "${SSH_AUTH_SOCK:-}" != "" \
        && ! ssh-add -l > /dev/null; \
    then
        echo "Add keys into ssh-agent:"
        find "${HOME}/.ssh" \
            -mindepth 1 \
            -maxdepth 1 \
            -type f \
            -not -name "*.pub" \
            \( \
                -name "identity" \
                -o -name "*_dsa" \
                -o -name "*_ecdsa" \
                -o -name "*_ed25519" \
                -o -name "*_rsa" \
                -o -name "*_rsa1" \
            \) \
            -exec ssh-add {} \;
    fi
}

bashrc::configure_ssh_command
bashrc::ssh_agent_auto_start_if_not_exists

#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Start a SSH anent if not exists and outside of tmux.
bashrc::start_ssh_agent_if_not_exists_and_outside_of_tmux()
{
    local readonly EXIT_CODE_OK=0
    local readonly EXIT_CODE_GENERAL_ERROR=1

    if ! command -v "ssh-agent" > /dev/null 2>&1; then
        return ${EXIT_CODE_GENERAL_ERROR}
    fi;

    if [[ "${TMUX:-}" != "" ]]; then
        return ${EXIT_CODE_OK}
    fi

    if [[ "${SSH_AUTH_SOCK:-}" != "" ]]; then
        return ${EXIT_CODE_OK}
    fi

    if [[ "${SSH_AGENT_PID}" != "" ]]; then
        return ${EXIT_CODE_OK}
    fi

    echo "Start a SSH agent: "
    eval "$(ssh-agent -s)"
    bashrc::add_all_ssh_keys_to_agent
    trap bashrc::kill_ssh_agent_outside_of_tmux EXIT
}

# Kill SSH agent when exit shell outside of tmux.
bashrc::kill_ssh_agent_outside_of_tmux()
{
    local readonly EXIT_CODE_OK=0

    if [[ "${TMUX:-}" != "" ]]; then
        return ${EXIT_CODE_OK}
    fi

    if [[ "${SSH_AGENT_PID:-}" != "" ]]; then
        eval "$(ssh-agent -k)"
    fi
}

# Add all of SSH keys to agent.
bashrc::add_all_ssh_keys_to_agent()
{
    local readonly EXIT_CODE_OK=0
    local readonly EXIT_CODE_GENERAL_ERROR=1

    if [[ "${SSH_AUTH_SOCK:-}" == "" ]]; then
        return ${EXIT_CODE_GENERAL_ERROR}
    fi

    if ! test -d "${HOME}/.ssh"; then
        return ${EXIT_CODE_OK}
    fi

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
}

bashrc::start_ssh_agent_if_not_exists_and_outside_of_tmux

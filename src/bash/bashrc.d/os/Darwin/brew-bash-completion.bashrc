#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash
if [ -z "${BASH_VERSION:-}" ] || [ -z "${PS1:-}" ]; then
    return
fi

# Create symbolic link from bash_completion.d into share directory for bash compeletion
function bashrc::macos::create-symbolic-link-for-brew-bash-completions
{
    local readonly brew_bash_completion_dir_source="/usr/local/etc/bash_completion.d"
    local readonly brew_bash_completion_dir_link="${HOME}/.bash/share/brew/share/bash-completion/completions"
    local readonly brew_bash_completion_dir=$(dirname "${brew_bash_completion_dir_link}")
    if ! test -d "${brew_bash_completion_dir}"; then
        mkdir -v -p "${brew_bash_completion_dir}"
    fi

    if ! test -L "${brew_bash_completion_dir_link}"; then
        ln -v -s "${brew_bash_completion_dir_source}" "${brew_bash_completion_dir_link}"
    fi
}

bashrc::macos::create-symbolic-link-for-brew-bash-completions

#!/usr/bin/env bash
# vim: set filetype=sh

# Homebrew for MacOS.
# @see https://brew.sh/

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure env variables for `brew` command
bashrc::macos::configure_brew_command()
{
    # Disable anonymous analytics.
    export HOMEBREW_NO_ANALYTICS=1

    # Do not use the GitHub API.
    export HOMEBREW_NO_GITHUB_API=1

    # Do not auto update before running brew install, brew upgrade or brew tap.
    export HOMEBREW_NO_AUTO_UPDATE=1

    # Homebrew will only check for autoupdates once per this seconds interval.
    local readonly ONE_HOUR_IN_SECONDS
    export HOMEBREW_AUTO_UPDATE_SECS="${ONE_HOUR_IN_SECONDS}"

    # Specify your defaults in this environment variable.
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # U[se the specified directory as the download cache.
    export HOMEBREW_CACHE="${HOME}/Library/Caches/Homebrew"


    # Return if not running on MacOS.
    local readonly OS_NAME_MACOS="Darwin"
    local os_name="$(uname -s)"
    if [[ "${os_name}" != "${OS_NAME_MACOS}" ]]; then
        return
    fi

    # Return if not installed.
    if ! command -v "brew" > /dev/null; then
        return
    fi

    # TODO Configure if brew installed
}

bashrc::macos::configure_brew_command_if_installed

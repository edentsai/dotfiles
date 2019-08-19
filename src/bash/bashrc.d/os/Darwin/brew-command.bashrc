#!/usr/bin/env bash
# vim: set filetype=sh

# Homebrew for MacOS.
# https://brew.sh/

# Bash configuration for `brew` command if installed.
function bashrc::macos::configure_brew_command_if_installed()
{
    # Return if not running on MacOS.
    local readonly OS_TYPE_MACOS="Darwin"
    local readonly os_type=$(uname -s)
    if [ "${os_type}" != "${OS_TYPE_MACOS}" ]; then
        return
    fi

    # Return if not installed.
    if ! command -v brew > /dev/null; then
        return
    fi

    # Disable anonymous analytics.
    export HOMEBREW_NO_ANALYTICS=1

    # Specify your defaults in this environment variable.
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # If you really need to use these commands with their normal names, you
    # can add a "gnubin" directory to your PATH from your bashrc like:
    unshift_paths_to_global "/usr/local/opt/coreutils/libexec/gnubin"

    # Additionally, you can access their man pages with normal names if you add
    # the "gnuman" directory to your MANPATH from your bashrc as well:
    unshift_manpaths_to_global "/usr/local/opt/coreutils/libexec/gnuman"
}

bashrc::macos::configure_brew_command_if_installed

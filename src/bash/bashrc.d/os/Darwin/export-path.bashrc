#!/usr/bin/env bash
# vim: set filetype=sh

# Export PATH environment variable on MacOS
function bashrc::macos::export_path()
{
    # Return if not running on MacOS.
    local readonly OS_TYPE_MACOS="Darwin"
    local readonly os_type=$(uname -s)
    if [ "${os_type}" != "${OS_TYPE_MACOS}" ]; then
        return
    fi

    export GOPATH="$HOME/workspace/go"
    unshift_paths_to_global "$GOPATH/bin"

    export WORKON_HOME="$HOME/.virtualenvs"
}

bashrc::macos::export_path

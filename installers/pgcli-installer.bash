#!/usr/bin/env bash
# vim: set filetype=sh:
#
# Pgcli is a command line interface for Postgres with auto-completion and syntax highlighting.
#
# Website: http://pgcli.com
# Github: https://github.com/dbcli/pgcli

function install_pgcli()
{
    # To install mycli via Python Package
    local pip=`which pip`
    if [ -n "$pip" ]; then
        echo "Install pgcli via Python Package:"
        $pip install --user "pgcli"
        echo "-- Pgcli installed."
        return
    fi

    # To install mycli via Homebrew
    local brew=`which brew`
    if [ -n "$brew" ]; then
        echo "Install pgcli via Homebrew:"
        $brew update
        $brew install pgcli
        echo "-- Pgcli installed."
        return
    fi

    # install failed
    echo "Cannot install Pgcli because 'pip' and 'brew' command not found."
}

install_pgcli

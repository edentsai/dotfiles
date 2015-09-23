#!/usr/bin/env bash
# vim: set filetype=sh:
#
# Mycli is a command line interface for MySQL, MariaDB,
# and Percona with auto-completion and syntax highlighting.
#
# Website : http://mycli.net
# Github: https://github.com/dbcli/mycli

function install_mycli()
{
    # To install mycli via Python Package
    local pip=`which pip`
    if [ -n "$pip" ]; then
        echo "Install mycli via Python Package:"
        $pip install --user "mycli"
        echo "-- Mycli installed."
        return
    fi

    # To install mycli via Homebrew
    local brew=`which brew`
    if [ -n "$brew" ]; then
        echo "Install Mycli via Homebrew:"
        $brew update
        $brew install mycli
        echo "-- Mycli installed."
        return
    fi

    # install failed
    echo "Cannot install Mycli because 'pip' and 'brew' command not found."
}

install_mycli

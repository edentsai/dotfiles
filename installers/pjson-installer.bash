#!/usr/bin/env bash
# vim: set filetype=sh:
#
# Pjson like python -mjson.tool but with moar colors (and less conf).
#
# Github: https://github.com/igorgue/pjson

function install_pjson()
{
    # To install mycli via Python Package
    local pip=`which pip`
    if [ -n "$pip" ]; then
        echo "Install Pjson via Python Package:"
        $pip install --user "pjson"
        echo "-- Pjson installed."
        return
    fi

    # install failed
    echo "Cannot install pjson because 'pip' command not found."
}

install_pjson

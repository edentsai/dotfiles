#!/usr/bin/env bash
# vim: set filetype=sh:
#
# Composer is a tool for dependency management in PHP. It allows you to
# declare the libraries your project depends on and it will manage
# (install/update) them for you.
#
# Website: https://getcomposer.org/
# Github: https://github.com/composer/composer

function install_composer()
{
    local composer_installer_url="https://getcomposer.org/installer"

    # Set the installation directory.
    local install_prefix="$1"
    if [ ! -d "$install_prefix" ]; then
        install_prefix="$HOME/.bin"
    fi;

    echo "Installing Composer to '$install_prefix':"
    echo "-- Download installer from $composer_installer_url, then execute it."
    curl -sS "$composer_installer_url" | php

    echo -n "-- Move "
    mv -v "$PWD/composer.phar" "$install_prefix/composer"

    echo "-- Composer installed."
}

install_prefix="$1"
install_composer "$install_prefix"

unset install_prefix

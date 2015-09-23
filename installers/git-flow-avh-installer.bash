#!/usr/bin/env bash
# vim: set filetype=sh:
#
# Git-Flow (AVH Edition)
# A collection of Git extensions to provide high-level repository operations
# for Vincent Driessen's branching model. This fork adds functionality not added to the original branch.
#
# Github: https://github.com/petervanderdoes/gitflow-avh
# Reference: http://nvie.com/posts/a-successful-git-branching-model/

function install_git_flow_avh()
{
    local gitflow_install_url="https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh"
    local gitflow_installer="$PWD/$(basename $gitflow_install_url)"

    # Set the installation directory.
    local install_prefix="$1"
    if [ ! -d "$install_prefix" ]; then
        install_prefix="$HOME/.bin"
    fi;

    echo "Installing Git-flow (AVH) to $install_prefix:"
    echo "-- Downloading Git-flow (AVH) installer:"
    curl -OL $gitflow_install_url

    echo "-- Execute $gitflow_installer:"
    PREFIX=$PWD bash $gitflow_installer install stable

    # Move git-flow scripts to directory of install prefix.
    for script_file in `ls $PWD/bin/gitflow-* $PWD/bin/git-flow*`; do
        script_name=`basename $script_file`
        echo "$install_prefix/$script_name"
        mv "$script_file" "$install_prefix/$script_name"
    done

    echo "-- Remove unused files"
    rm -fv "$gitflow_installer"
    rm -rfv "$PWD/gitflow"
    rm -rfv "$PWD/share"
    rm -dv "$PWD/bin"

    echo "-- Git-flow (AVH) installed."
}

install_prefix="$1"
install_git_flow_avh "$install_prefix"

unset install_prefix

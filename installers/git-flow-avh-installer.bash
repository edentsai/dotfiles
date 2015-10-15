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
    local make=`which gmake`
    if [ -z "$make" ]; then
        make=`which make`
    fi
    echo "$make"
    if [ -z "$make" ]; then
        echo "Cannot install 'git-flow-avh' because 'gmake' and 'make' command not found."
        return
    fi

    # Set the installation directory.
    local install_prefix="$1"
    if [ ! -d "$install_prefix" ]; then
        install_prefix="$HOME/.bin"
    fi;
    local shareprefix="$HOME/.bash/share"

    # To install 'git-flow-avh' via Git Clone
    echo "Install 'git-flow-avh' into '$install_prefix'"
    cd "/tmp"
    rm -rf "/tmp/gitflow-avh"

    echo -n "-- "
    git clone "https://github.com/petervanderdoes/gitflow-avh"
    cd "gitflow-avh"

    echo "-- Compile 'gitflow-avh' files"
    mkdir -p "installed-gitflow-avh"
    $make prefix="/tmp/gitflow-avh/installed-gitflow-avh" install

    echo "-- Move commands into '$install_prefix':"
    cp -rfv installed-gitflow-avh/bin/* $install_prefix/.

    echo "-- Move shares into '$shareprefix':"
    cp -rfv "installed-gitflow-avh/share" $shareprefix/.

    cd "/tmp"
    rm -rf "/tmp/gitflow-avh"

    echo "-- 'gitflow-avh' installed."
}

install_prefix="$1"
install_git_flow_avh "$install_prefix"

unset install_prefix

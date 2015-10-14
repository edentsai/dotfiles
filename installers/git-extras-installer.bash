#!/usr/bin/env bash
# vim: set filetype=sh:
#
# git-extras is GIT utilities -- repo summary, repl, changelog population, author commit percentages and more
#
# Github: https://github.com/tj/git-extras

function install_git_extras()
{
    local make=`which gmake`
    if [ -z "$make" ]; then
        make=`which make`
    fi
    echo "$make"
    if [ -z "$make" ]; then
        echo "Cannot install 'git-extras' because 'gmake' and 'make' command not found."
        return
    fi

    # To install 'git-extras' via Git Clone
    local prefix="$HOME"
    local binprefix="$HOME/.bin"
    local manprefix="$HOME/.bash/share/man/man1"
    echo "Install 'git-extras' into '$binprefix'"
    cd "/tmp"
    rm -rf "/tmp/git-extras"

    echo -n "-- "
    git clone "https://github.com/tj/git-extras.git"
    cd "git-extras"
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) &> /dev/null

    echo "-- Compile 'git-extras' files"
    PREFIX="$prefix" BINPREFIX="$binprefix" MANPREFIX="$manprefix" $make install

    cd "/tmp"
    rm -rf "/tmp/git-extras"

    echo "-- 'git-extras' installed."
}

install_git_extras

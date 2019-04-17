#!/usr/bin/env bash
# vim: set filetype=sh:
#
# fzf is a general-purpose command-line fuzzy finder.
#
# Github: https://github.com/junegunn/fzf

function install_fzf()
{
    # Set the installation directory.
    local installer_file="$1/_bash/submodules/fzf/install"
    if [ ! -f "$installer_file" ]; then
        return 0;
    fi;

    echo "Installing fzf by '$installer_file':"
    gem install curses --user-install
    bash "$installer_file"

    echo "-- fzf installed."
}

dotfiles_dir="$1"
install_fzf "$dotfiles_dir"

unset dotfiles_dir

#!/usr/bin/env bash
# vim: set filetype=sh:

DIFF=`which diff`

# Get absolute path of dotfiles directory.
UNINSTALLER_PATH="$PWD/$0"
DOTFILES_DIR=$(dirname "$UNINSTALLER_PATH")

# Remove all dotfile links.
function remove_dotfile_links()
{
    local filepath="$1"
    local filename=`basename $filepath`
    if [ -e "$filepath" ]; then
        # Skip if the $filepath is $DOTFILES_DIR
        if [ "$DOTFILES_DIR" != "$filepath" ]; then
            # Remove dotfile link in $HOME if it exists.
            local target_filepath="$HOME/${filename/_/.}"
            if [ -L "$target_filepath" ] && [ -z "$($DIFF $filepath $target_filepath)" ]; then
                echo "Remove '$target_filepath'"
                rm "$target_filepath"
            fi
        fi

        # Remove dotfile links by recursive if $filepath is a directory
        if [ -d "$filepath" ]; then
            local file
            for file in $filepath/_*; do
                remove_dotfile_links $file
            done
        fi
    fi

    unset filepath filename target_filepath file
}

# Uninstall dotfiles.
remove_dotfile_links "$DOTFILES_DIR"

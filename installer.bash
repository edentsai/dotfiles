#!/usr/bin/env bash
# vim: set filetype=sh:

DIFF=`which diff`

# Get absolute path of dotfiles directory.
INSTALLER_PATH="$PWD/$0"
DOTFILES_DIR=$(dirname "$INSTALLER_PATH")

# Create dotfile links to $HOME.
function create_dotfile_links()
{
    local filepath="$1"
    local filename=`basename $filepath`

    if [ -e "$filepath" ]; then
        # Skip if the $filepath is $DOTFILES_DIR
        if [ "$DOTFILES_DIR" != "$filepath" ]; then
            # Create a symbolic link from $HOME to $filepath
            if [ ! -e $target_filepath ] || [ -n "$($DIFF $filepath $target_filepath)" ]; then
                echo "Create symbolic links '$filepath' to '$target_filepath'"
                ln -sfn "$filepath" "$target_filepath"
            fi
        fi

        # Create symbolic links from $HOME to $filepath by recursive if $filepath is a directory
        if [ -d "$filepath" ]; then
            for file in $filepath/_*; do
                create_dotfile_links $file
            done
        fi
    fi

    unset filepath filename target_filepath
}

# Run installer.
echo "Install and create symbolic links to '$DOTFILES_DIR':"
create_dotfile_links $DOTFILES_DIR

echo "Source '$HOME/.bash_profile' after installed."
source "$HOME/.bash_profile"

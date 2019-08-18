#!/usr/bin/env bash
# vim: set filetype=sh:

DIFF=`which diff`

# Get absolute path of dotfiles directory.
UNINSTALLER_PATH="$PWD/$0"
DOTFILES_DIR=$(dirname "$UNINSTALLER_PATH")

# Prepare a directory for backup old dotfiles.
BACKUP_DIR="$1"
if [ -z "$BACKUP_DIR" ]; then
    # Restore the last backup dotfiles by default.
    BACKUP_DIR=`find "$DOTFILES_DIR/backup" -depth 1 | grep -v '.gitkeep' | sort | tail -1`
elif [ ! -d "$BACKUP_DIR" ]; then
    echo "The '$BACKUP_DIR' not a directory."
    exit
else
    # Remove the slash suffix.
    BACKUP_DIR="$(dirname $1)/$(basename $1)"
fi

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
                restore_backup_dotfile "$filepath"
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

# Restore dotfile from the specified backup directory by a specified dotfile
function restore_backup_dotfile()
{
    local filepath="$1"
    local filename=`basename $filepath`
    local backup_filepath="$BACKUP_DIR/${filename/_/.}"
    local target_filepath="$HOME/$(basename $backup_filepath)"

    if [ -e "$backup_filepath" ]; then
        echo "Restore '$backup_filepath' to '$target_filepath'."
        cp "$backup_filepath" "$target_filepath"
    fi

    unset backup_dir filepath filename target_filepath
}

# Uninstall dotfiles.
remove_dotfile_links "$DOTFILES_DIR"
